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

module HasMedia
  extend ActiveSupport::Concern

  included do
    has_many :media, as: :referer, dependent: :destroy
  end

  def original
    original_medium = media.only_originals.first
    return original_medium if original_medium

    original_medium = media.create({ medium_use: "original" })
    original_medium.pick_random_thumbnail
    original_medium
  end

  def poster_image
    original.thumbnail
  end

  def medium_thumbnail
    original.thumbnail
  end

  module ClassMethods
    def only_with_medium_thumbnail
      joins(:media).where("media.medium_use = 'original' AND media.thumbnail_file_name IS NOT NULL")
    end
  end
end
