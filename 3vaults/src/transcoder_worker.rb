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
require_relative "fileserver"
require_relative "transcoder"
require "open3"
require "shellwords"

class TranscoderWorker
  include Resque::Plugins::Status
  @queue = :transcoder

  def perform
    begin
      source_path = Fileserver.get_storage_link_path(options["source_id"])
      tmp_path = Transcoder.get_transcoding_path(options["destination_id"])
      dest_path = Fileserver.get_storage_path(options["destination"], options["destination_id"])

      movie = FFMPEG::Movie.new(source_path)
      movie.valid? or raise StandardError, "ffmpeg failed to read the movie" # can happen if ffmpeg is not installed

      case options["transcoder"]
      when "ffmpeg", "ffmpeg-faststart"
        transcoder = FFMPEG::Transcoder.new(movie, tmp_path, options["arguments"].shellsplit)
        transcoder.run

        info = Transcoder.get_movie_info(transcoder.encoded)
        info[:transcoding_duration] = transcoder.encoded.time
        set_status(info: info)
      when "ffmpeg-sequence"
        file_pattern = options["file_pattern"]
        transcoder = FFMPEG::Transcoder.new(movie, "#{tmp_path}/#{file_pattern}", options["arguments"].shellsplit)
        begin
          transcoder.run
        rescue
        end
      else
        raise StandardError, "invalid transcoder"
      end

      if options["transcoder"] == "ffmpeg-faststart"
        Open3.capture2("qt-faststart", tmp_path, tmp_path + ".tmp")
        File.rename(tmp_path + ".tmp", tmp_path)
      end

      Fileserver.move_file_from(tmp_path, options["destination_id"], options["destination"])
    rescue
      begin
        File.unlink(tmp_path)
        Dir.unlink(tmp_path)
      rescue
      end
      raise
    end
  end
end

class TranscoderWorker::Error < StandardError
end
