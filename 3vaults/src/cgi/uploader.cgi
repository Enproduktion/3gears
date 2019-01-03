#!/usr/bin/env ruby

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

require "cgi"
require "json"
require_relative "../fileserver"

class ServerHalt < StandardError
  attr_reader :http_status

  def initialize(http_status)
    @http_status = http_status
  end
end

begin
  ENV["REQUEST_METHOD"] == "OPTIONS" and raise ServerHalt.new(:ok)

  query     = CGI.parse(ENV["QUERY_STRING"] || "")
  secure_id = query["secure_id"].first
  start     = query["start"].first.to_i

  Fileserver.valid_token?(secure_id) or raise ServerHalt.new(:unprocessable_entity), "Invalid secure id"

  ticket_path = Fileserver.get_ticket_path(secure_id)
  uploading_path = Fileserver.get_uploading_path(secure_id)

  File.exists?(ticket_path) or raise ServerHalt.new(:not_found), "Ticket not found"

  File.open(ticket_path, "r") do |ticket_file|
    ticket_file.flock(File::LOCK_SH)

    case ENV["REQUEST_METHOD"]
    when "GET"
      total_copied = File.size?(uploading_path) || 0

      $status = :ok
      $body = total_copied
    when "POST"
      filesize = ticket_file.read.to_i
      length = ENV["CONTENT_LENGTH"].to_i
      start >= 0 && start + length <= filesize or raise ServerHalt.new(:unprocessable_entity), "Invalid upload range"
      copied = 0

      File.open(uploading_path, File::WRONLY | File::CREAT) do |file|
        file.seek(start)
        copied = IO.copy_stream($stdin, file, length)
      end

      $status = :ok
      $body = copied
    end
  end

rescue ServerHalt => error
  $status = error.http_status
  $body = error.message

rescue => error
  $status = :internal_server_error
  # $body = error.message

ensure
  HTTP_STATUS = {
    ok:                    "200 OK",
    forbidden:             "403 Forbidden",
    not_found:             "404 Not Found",
    method_not_allowed:    "405 Method Not Allowed",
    unprocessable_entity:  "422 Unprocessable Entity",
    internal_server_error: "500 Internal Server Error",
  }

  $status ||= :method_not_allowed

  header = {
    "Status" => HTTP_STATUS[$status],
    "Content-Type" => "text/plain",
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Headers" => "Origin, Content-Type",
    "Access-Control-Max-Age" => 86400,
  }

  header.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts

  puts $body if $body
end
