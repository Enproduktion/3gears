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

module Medium::FileserverActions
  extend ActiveSupport::Concern

  def upload_completed
    uploading? or return

    Resque.enqueue(Medium::Worker::FinishUpload, id)

    self.status = "upload_finishing"
    save!
  end

  def generate_thumbnails
    return unless duration && duration > 0

    seek = 0.02 * duration # skip first 2%
    rate = 52.08 / duration # 50 frames, ignore last 2%

    presets = [TranscodingPreset.new({
      use: "thumbnails",
      settings: {
        transcoder: "ffmpeg-sequence",
        arguments: "-f image2 -ss #{seek} -r #{rate} -an -vframes 50",
        file_pattern: "%02d.png",
      }.to_json,
    }, without_protection: true)]

    transcode(presets)
  end

  def transcode(presets)
    ready? or return
    Resque.enqueue(Medium::Worker::Transcode, self.id, presets)
  end

  def delete_from_server
    fileserver_handle or return
    Resque.enqueue(Medium::Worker::Delete, status, fileserver_handle)
  end

  def update_thumbnail
    Resque.enqueue(Medium::Worker::UpdateThumbnail, self.id)
  end

  # blocking
  def publish(name = nil, append_extension = true)
    ready? or return

    unless name
      title = referer.respond_to?(:title) && referer.title
      preset = transcoding_preset && transcoding_preset.name

      if !title.blank? && preset
        name = "#{title} (#{preset})"
      elsif !title.blank?
        name = title
      elsif preset
        name = preset
      else
        name = "unnamed"
      end
    end

    if append_extension
      if transcoding_preset
        name += ".#{transcoding_preset.extension}" if transcoding_preset.extension
      elsif original?
        name += File.extname(original_filename)
      end
    end

    MediaFileserver.publish_as(fileserver_handle, name)
    self.public_name = name
    self.status = "published"
    save!
  end

  # blocking
  def request_medium_info
    info = MediaFileserver.get_info(fileserver_handle)
    update_attributes(info)
    save!
  end

  # blocking
  def request_upload_ticket(filename, filesize)
    tabula_rasa? or return

    self.original_filename = filename
    self.filesize = filesize

    self.fileserver_handle = MediaFileserver.request_ticket(filesize)
    self.status = "uploading"

    save!
  end

  module ClassMethods
    # blocking
    def update_transcoding_status
      pending_handles = transcoding.all.map(&:fileserver_handle)
      return if pending_handles.empty?

      statuses = MediaFileserver.transcoding_statuses(pending_handles)

      statuses.each do |fileserver_handle, status|
        begin
          status or status = { "status" => "failed", "message" => "lost" }

          case status["status"]
          when "completed"
            info = status["info"] || { }
            info = info.with_indifferent_access

            format = find_by_fileserver_handle!(fileserver_handle)
            format.update_attributes(info)
            format.status = "transcoding_finished"
            format.save!

            format.publish

            if format.for_thumbnails?
              if format.original
                format.original.update_thumbnail
                format.original.save!
              end
            else
              format.generate_thumbnails
            end
          when "failed"
            message = status["message"]

            format = find_by_fileserver_handle!(fileserver_handle)
            format.status = "transcoding_failed"
            format.transcoding_error = message
            format.save!
          end
        rescue => error
          puts error
          logger.error(error) # TODO: does this work?
        end
      end
    end
  end
end
