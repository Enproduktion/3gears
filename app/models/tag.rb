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

class Tag < ActiveRecord::Base

  include QuickSearch

  validates :name, presence: true, uniqueness: true

  has_many :taggables, through: :tag_references
  has_many :tag_references
  has_many :media_time_tags, class_name: "MediumTimeTag"

  scope :most_used, -> { joins(:tag_references).references(:tag_references).group("tag_references.tag_id").order("count(tag_references.tag_id) DESC") }
  scope :with_media_time_tags, -> { joins(:media_time_tags).references(:media_time_tags) }

  def self.most_used_accessible_footage_tags(current_ability, limit)
    footages = Footage.accessible_by(current_ability).includes(:tags)
    tag_ids  = footages.map(&:tag_ids).flatten
    Tag.where(id: tag_ids).most_used.limit(limit)
  end

  #
  # Class methods
  #
  class << self
    def autocomplete_suggestions(term, count, options = {})
      limit = sanitize(count)

      current_ability = options[:current_ability]
      if current_ability
        tag_ids = Footage.accessible_by(current_ability).map do |footage|
          footage.tags.map(&:id) + footage.original.tags.map(&:id)
        end
        tag_ids = tag_ids.flatten

        Tag.where(id: tag_ids).where("name LIKE ?", "#{term}%").limit(limit)
      else
        Tag.where("name LIKE ?", "#{term}%").limit(limit)
      end
    end

    def quick_search(query, current_ability = nil)
      Tag.default_quick_search(query, {url: 'search_path', field: 'name', title: 'Tag', current_ability: current_ability})
    end

    def min_year
      Tag.with_media_time_tags.map(&:to_year_i).compact.min
    end

    def max_year
      Tag.with_media_time_tags.map(&:to_year_i).compact.max
    end
  end

  #
  # Instance methods
  #
  def tag_names
    collect(&:name).join ' '
  end

  def is_year?
    !!name.match(/[0-9]{4}/)
  end

  def to_year_i
    name.to_i if is_year?
  end

  def destroy_unused_tag
    if tag_references.empty? && media_time_tags.empty?
      destroy!
    end
  end
end
