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

require "json"
require_relative "transcoder"
require_relative "app_logger"

get "/mediuminfo/*" do |id|
  info = Transcoder.get_medium_info(id)

  content_type :json
  info.to_json
end

post "/transcodings" do
  source_id = params[:source_id]
  begin
    jobs = JSON.parse(params[:jobs] || "", symbolize_names: true)
  rescue JSON::JSONError
    raise Fileserver::ParameterError, "invalid job list"
  end

  transcodings = Transcoder.transcode(source_id, jobs)

  transcodings.each do |transcoding|
    transcoding[:started] and AppLogger.get.info("Transcoding file #{source_id} to #{transcoding[:id]}")
  end

  content_type :json
  transcodings.to_json
end

get "/transcodings" do
  destination_ids = params[:destination_ids]
  destination_ids.nil? || destination_ids.is_a?(Array) or halt 422

  statuses = Transcoder.get_statuses(destination_ids)

  result = { }

  statuses.each do |destination_id, status|
    if status.nil?
      result[destination_id] = nil
      next
    end

    case status.status
    when "completed"
      result[destination_id] = { status: "completed", info: status["info"] }
    when "failed"
      result[destination_id] = { status: "failed", message: status.message }
    else
      result[destination_id] = { status: "pending" }
    end
  end

  content_type :json
  result.to_json
end
