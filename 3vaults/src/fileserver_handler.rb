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

require_relative "fileserver"
require_relative "app_logger"

# Create upload ticket
post "/tickets" do
  size = params[:size].to_i

  secure_id = Fileserver.get_upload_ticket(size)
  AppLogger.get.info("Created ticket #{secure_id}")
  secure_id
end

# Delete upload ticket
delete "/tickets/*" do |secure_id|
  Fileserver.delete_upload_ticket(secure_id)
  AppLogger.get.info("Deleted ticket #{secure_id}")
  ""
end

# Move to another storage and/or publish file
put "/files/*" do |id|
  move_to = params[:move_to]
  publish_as = params[:publish_as]

  if move_to
    Fileserver.move_file(id, move_to)
    AppLogger.get.info("Moved file #{id} to #{move_to}")
  end

  if publish_as
    Fileserver.publish_file(id, publish_as)
    AppLogger.get.info("Published file #{id} as #{publish_as}")
  end

  ""
end

# Delete file
delete "/files/*" do |id|
  Fileserver.trash_file(id)
  AppLogger.get.info("Deleted file #{id}")
  ""
end

error Fileserver::NotFound do
  [404, env["sinatra.error"].message]
end

error Fileserver::ParameterError do
  [422, env["sinatra.error"].message]
end

error Fileserver::Locked do
  [423, env["sinatra.error"].message]
end
