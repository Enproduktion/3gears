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

class Still < ActiveRecord::Base
  default_value_for :abstract, value: "", allows_nil: false

  # Relations
  belongs_to :movie_or_idea
  
  # Attachment
  has_attached_file :content,
    styles: {
      full:  { geometry: "1440x810>", format: :jpg, convert_options: "-quality 80 -interlace plane" },
      thumb: { geometry: "276x144>", format: :jpg, convert_options: "-quality 80 -interlace plane" },
    },
    hash_secret: Rails.application.config.paperclip_secret,
    url: "/system/:class/:attachment/:id/:hash-:style.:extension",
    hash_data: ":class/:attachment/:id"

  validates_attachment :content, content_type: {
    content_type: ["image/jpeg", "image/png", "image/gif"]
  }

  # validates_presence_of :movie_or_idea
  before_validation do
    self.abstract ||= ""
  end
  
  validates_exclusion_of :title, :abstract, in: [nil], message: "cannot be nil"
  validates_attachment_presence :content

  include CheckAttachment
end
