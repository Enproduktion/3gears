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

require "rubygems"
require "bundler/setup"

require "sinatra"
require "resque"
require "resque-status"

require_relative "app_config"

auth_token = ENV["FRONTEND_AUTH_TOKEN"]
if auth_token.nil? or auth_token == ""
  raise "Environment variable FRONTEND_AUTH_TOKEN is empty."
end

Resque.redis = AppConfig.get["redis"]["server"]
Resque::Plugins::Status::Hash.expire_in = 24 * 3600 # one day

use Rack::Auth::Basic, "fileserver" do |username, password|
  password == auth_token
end

before do
  content_type :text
end

require_relative "fileserver_handler"
require_relative "transcoder_handler"
