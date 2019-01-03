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

class Asset < ActiveRecord::Base
  acts_as_list scope: :article

  # Relations
  belongs_to :article

  # Attachment
  has_attached_file :content,
    :styles => {
      :full =>   { :geometry => "864x486>", :format => :jpg, :convert_options => "-quality 80 -interlace plane" },
      :big =>    { :geometry => "640x360#", :format => :jpg, :convert_options => "-quality 80 -interlace plane" },
      :medium => { :geometry => "464x261#", :format => :jpg, :convert_options => "-quality 80 -interlace plane" },
      :small =>  { :geometry => "128x72#",  :format => :jpg, :convert_options => "-quality 80 -interlace plane" },
      :thumb =>  { :geometry => "208x117#", :format => :jpg, :convert_options => "-quality 80 -interlace plane" }
    },
    hash_secret: Rails.application.config.paperclip_secret,
    url: "/system/:class/:attachment/:id/:hash-:style.:extension",
    hash_data: ":class/:attachment/:id"

  # validates_presence_of :article
  validates_attachment_presence :content
  validates_attachment :content, content_type: {
    content_type: ["image/jpeg", "image/png", "image/gif"]
  }

  include CheckAttachment
end
