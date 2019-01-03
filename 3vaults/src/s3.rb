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

require "aws-sdk"
require_relative "app_config"

class S3
  @region_name = ENV.fetch("3VAULTS_S3_REGION", "")
  @endpoint_name = ENV.fetch("3VAULTS_S3_ENDPOINT", "")
  @bucket_name = ENV.fetch("3VAULTS_S3_BUCKET", "")

  def self.active
    @region_name != ""
  end

  def self.bucket
    return @bucket if @bucket

    config = {
      region: @region_name,
      force_path_style: true,
    }
    config[:endpoint] = @endpoint_name if @endpoint_name != ""

    @client = Aws::S3::Client.new(config)
    @resource = Aws::S3::Resource.new(client: @client)
    return @bucket = @resource.bucket(@bucket_name)
  end
end
