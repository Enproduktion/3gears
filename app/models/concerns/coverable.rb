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

module Coverable

  extend ActiveSupport::Concern

  included do
    has_attached_file :cover,
      styles: {
        big: { geometry: "x500", format: :jpg, convert_options: "-quality 80 -interlace plane" }
      },
      url: "/system/:class/:attachment/:id/:style.:extension",
      default_url: ActionController::Base.helpers.asset_path("assets/cover/:style.jpg")

    validates_attachment :avatar, content_type: {
      content_type: ["image/jpeg", "image/png", "image/gif"]
    }
  end

end
