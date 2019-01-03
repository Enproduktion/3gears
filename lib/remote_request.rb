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

require "net/http"

class RemoteRequest
  def self.delete(args)
    prepare_and_send_request(args, 'delete', Net::HTTP::Delete.new(args[:path]))
  end

  def self.get(args)
    prepare_and_send_request(args, 'get', Net::HTTP::Get.new(args[:path]))
  end

  def self.post(args)
    prepare_and_send_request(args, 'post', Net::HTTP::Post.new(args[:path]))
  end

  def self.put(args)
    prepare_and_send_request(args, 'put', Net::HTTP::Put.new(args[:path]))
  end

  private

  def self.perform_request(request, host, port, user, pass)
    request.basic_auth(user, pass) if user || pass

    begin
      response = Net::HTTP.start(host, port) do |http|
        http.request(request)
      end
    rescue => error
      raise RequestError.new, error.message
    end

    unless response.is_a?(Net::HTTPSuccess)
      if Rails.env == "development"
        raise RequestError.new(response.code, response.body), "Server error (#{host}:#{port}#{request.path}) #{response.code} #{response.body}"
      else
        raise RequestError.new(response.code, response.body), "Server error #{response.code}"
      end
    end

    response.body
  end

  def self.prepare_and_send_request(args, type, request)
    case type
    when 'get', 'delete'
      request.set_form_data(args[:params]) if args[:params]
    when 'post', 'put'
      request.set_form_data(args[:params] || { })
    end
    perform_request(request, args[:host], args[:port], args[:user], args[:pass])
  end
end

class RemoteRequest::RequestError < StandardError
  attr_reader :code, :body

  def initialize(code = nil, body = nil)
    @code = code
    @body = body
  end
end
