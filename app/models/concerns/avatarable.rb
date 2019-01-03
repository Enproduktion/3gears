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

module Avatarable

  extend ActiveSupport::Concern

  included do
    has_attached_file :avatar,
      styles: {
        avatar: { geometry: "400x400#", format: :jpg, convert_options: "-quality 100 -interlace plane" },
        big:    { geometry: "125x125#", format: :jpg, convert_options: "-quality 100 -interlace plane" },
        medium: { geometry: "60x60#",   format: :jpg, convert_options: "-quality 100 -interlace plane" },
        small:  { geometry: "44x44#",   format: :jpg, convert_options: "-quality 100 -interlace plane" },
        tiny:   { geometry: "46x12#",   format: :png },
      },
      url: "/system/:class/:attachment/:id/:style.:extension",
      # default_url: lambda {|attach| ActionController::Base.helpers.asset_path("assets/avatar/#{attach.instance.class.name.underscore}/:style.jpg")}
      default_url: "/avatars/original/missing.png"

    validates_attachment :avatar, content_type: {
      content_type: ["image/jpeg", "image/png", "image/gif"]
    }
  end

end
