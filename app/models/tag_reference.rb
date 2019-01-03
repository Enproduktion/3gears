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

class TagReference < ActiveRecord::Base
  # Relations
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  # Validations
  validates :tag, :taggable, presence: true
  validates :tag, uniqueness: { scope: [:taggable_id, :taggable_type] }

  after_save :update_search_index
  after_destroy :destroy_unused_tag

  def destroy_unused_tag
    tag.destroy_unused_tag
  end

  def update_search_index
    if taggable.kind_of? Footage
      ThinkingSphinx::RealTime::Callbacks::RealTimeCallbacks.new(:footage).after_save(taggable)
    end
  end
  
  def name=(val)
    self.tag = Tag.find_or_create_by(name: val)
  end

  def as_json(val)
    json = super.as_json(val)
    json[:tag_name] = self.tag.name
    json
  end
end
