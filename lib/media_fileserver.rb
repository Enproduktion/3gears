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

class MediaFileserver
  def self.request_ticket(size)
    RemoteRequest.post(
      host: request_host, port: request_port, pass: request_password,
      path: "/tickets", params: { size: size }
    )
  end

  def self.move_to(id, storage)
    RemoteRequest.put(
      host: request_host, port: request_port, pass: request_password,
      path: "/files/#{id}", params: { move_to: storage }
    )
  end

  def self.publish_as(id, name)
    RemoteRequest.put(
      host: request_host, port: request_port, pass: request_password,
      path: "/files/#{id}", params: { publish_as: name }
    )
  end

  def self.get_info(id)
    info = RemoteRequest.get(
      host: request_host, port: request_port, pass: request_password,
      path: "/mediuminfo/#{id}"
    )
    JSON.parse(info, symbolize_names: true)
  end

  def self.transcode(id, jobs)
    transcodings = RemoteRequest.post(
      host: request_host, port: request_port, pass: request_password,
      path: "/transcodings", params: { source_id: id, jobs: jobs.to_json }
    )
    JSON.parse(transcodings, symbolize_names: true)
  end

  def self.transcoding_statuses(ids)
    statuses = RemoteRequest.get(
      host: request_host, port: request_port, pass: request_password,
      path: "/transcodings", params: { "destination_ids[]" => ids }
    )
    JSON.parse(statuses)
  end

  def self.upload_url_for(id)
    server_uri = Rails.application.config.media_fileserver_options[:upload_url]
    "#{server_uri}?secure_id=#{id}&"
  end

  def self.public_url_for(id, name)
    name = URI.escape(name)
    Rails.application.config.media_fileserver_options[:public_url] + "#{id}/#{name}"
  end

  def self.s3_url_for(id, name)
    name = URI.escape(name)
    Rails.application.config.media_fileserver_options[:s3_url] + "#{id}/#{name}"
  end

  private

  def self.request_host
    Rails.application.config.media_fileserver_options[:host]
  end

  def self.request_port
    Rails.application.config.media_fileserver_options[:port]
  end

  def self.request_password
    Rails.application.config.media_fileserver_options[:auth]
  end
end
