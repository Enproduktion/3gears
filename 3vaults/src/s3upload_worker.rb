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

require_relative "s3"
require_relative "app_logger"

class S3UploadWorker
  @queue = :s3uploader

  def self.perform(path, key)
    AppLogger.get.info("Uploading to S3: #{path} -> #{key}\n")
    begin
      File.open(path, "r") do |file|
        S3.bucket.put_object({
          body: file,
          key: key,
        })
      end
    rescue => e
      AppLogger.get.error(e.message)
      AppLogger.get.error(e.backtrack)
      raise
    end
  end
end
