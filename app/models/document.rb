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

class Document < ActiveRecord::Base
  # 
  # Relations
  # 

  # belongs_to :documentable, polymorphic: true
  belongs_to :movie_or_idea

  # 
  # Attachment
  # 
  has_attached_file :document,
    hash_secret: Rails.application.config.paperclip_secret,
    url: "/system/:class/:attachment/:id/:hash-:style.:extension",
    hash_data: ":class/:attachment/:id"

  # 
  # Validations
  # 
  validates_attachment_presence :document
  do_not_validate_attachment_file_type :document

  include CheckAttachment
end
