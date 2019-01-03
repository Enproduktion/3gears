# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "resque"
require "resque-status"
require "streamio-ffmpeg"
require_relative "transcoder_worker"
require_relative "fileserver"

class Transcoder
  def self.transcode(source_id, jobs)
    jobs.is_a?(Array) or raise Fileserver::ParameterError, "invalid job list"

    source_path = Fileserver.get_storage_link_path(source_id)
    File.exists?(source_path) or raise Fileserver::NotFound, "source file not found"

    transcodings = jobs.map do |job|
      begin
        settings = job[:settings]
        destination = job[:destination]

        settings or raise Fileserver::ParameterError, "no settings given"
        settings.is_a?(Hash) or raise Fileserver::ParameterError, "invalid settings" + settings + settings.class.name
        Fileserver.storage_exits?(destination) or raise Fileserver::NotFound, "destination not found"

        destination_id = Fileserver.generate_id
        tmp_path = get_transcoding_path(destination_id)

        case settings[:transcoder]
        when "ffmpeg", "ffmpeg-faststart"
          settings[:transcoder] or raise Fileserver::ParameterError, "no transcoder given"
          settings[:arguments] or raise Fileserver::ParameterError, "no transcoder arguments given"

          File.open(tmp_path, "w") { }
          TranscoderWorker.create(
            source_id: source_id,
            destination: destination,
            destination_id: destination_id,
            transcoder: settings[:transcoder],
            arguments: settings[:arguments],
          )
        when "ffmpeg-sequence"
          settings[:transcoder] or raise Fileserver::ParameterError, "no transcoder given"
          settings[:arguments] or raise Fileserver::ParameterError, "no transcoder arguments given"
          Fileserver.assert_valid_filename(settings[:file_pattern])

          Dir.mkdir(tmp_path)
          TranscoderWorker.create(
            source_id: source_id,
            destination: destination,
            destination_id: destination_id,
            transcoder: settings[:transcoder],
            arguments: settings[:arguments],
            file_pattern: settings[:file_pattern],
          )
        else
          raise Fileserver::ParameterError, "invalid transcoder"
        end

        { started: true, id: destination_id }
      rescue Fileserver::Error => error
        { started: false, message: error.message }
      end
    end
  end

  def self.get_medium_info(id)
    path = Fileserver.get_storage_link_path(id)
    File.exists?(path) or raise Fileserver::NotFound, "file not found"

    movie = FFMPEG::Movie.new(path)
    movie.valid? or return nil
    get_movie_info(movie)
  end

  def self.get_statuses(destination_ids)
    all_statuses = { }
    Resque::Plugins::Status::Hash.statuses.each do |status|
      begin
        all_statuses[status["options"]["destination_id"]] = status
      rescue
      end
    end

    return all_statuses unless destination_ids

    statuses = { }
    destination_ids.each do |destination_id|
      statuses[destination_id] = all_statuses[destination_id]
    end

    statuses
  end

  def self.get_transcoding_path(id)
    Fileserver.assert_valid_file_id(id)
    AppConfig.get["transcoder_directory"] + "/" + id
  end

  def self.get_movie_info(movie)
    field_map = {
      duration:             :duration,
      bitrate:              :bitrate,
      video_codec:          :video_codec,
      video_bitrate:        :video_bitrate,
      colorspace:           :colorspace,
      dar:                  :calculated_aspect_ratio,
      audio_codec:          :audio_codec,
      audio_bitrate:        :audio_bitrate,
      audio_sample_rate:    :audio_sample_rate,
      width:                :width,
      height:               :height,
      filesize:             :size,
      audio_channels:       :audio_channels,
      frame_rate:           :frame_rate,
      audio_info:           :audio_stream,
      video_info:           :video_stream,
    }

    info = field_map.to_a.map do |key, field|
      begin
        [key, movie.send(field)]
      rescue
        [key, nil]
      end
    end

    Hash[info]
  end
end
