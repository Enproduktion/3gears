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

require "open-uri"

class Medium::Worker::UpdateThumbnail
  @queue = :medium

  def self.perform(medium_id)
    medium = Medium.find(medium_id)

    medium.thumbnail = nil

    begin
      medium_with_thumbnail_index = medium
      while true
        thumbnail_index = medium_with_thumbnail_index.thumbnail_index
        break if thumbnail_index

        medium_with_thumbnail_index = medium_with_thumbnail_index.original
        return unless medium_with_thumbnail_index
      end

      thumbnails_medium = medium.transcodings.only_for_thumbnails.first or return
      path = thumbnails_medium.public_path or return
      name = "%02d.png" % thumbnail_index

      open("#{path}/#{name}") do |file|
        file.define_singleton_method :original_filename, lambda { name }
        medium.thumbnail = file
      end
    ensure
      medium.save!
    end
  end
end
