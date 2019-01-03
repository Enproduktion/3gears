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

class PublicationEntry < ActiveRecord::Base
  # Relations
  belongs_to :publication, polymorphic: true

  # Scopes
  scope :newest_first, -> { order(:published_at) }
  default_scope { includes(:publication) }

  def viewable_by?(user)
    viewable_by == nil || viewable_by == user.try(:id)
  end

  def self.viewable_by(user)
    where("viewable_by IS NULL OR viewable_by = ?", user && user.id)
  end

  # def self.with_tags(tag_list)
  #   condition = sanitize_sql_for_conditions(["tags.name in (?)", tag_list])
  #   joins("INNER JOIN tags ON taggable_id = publication_id AND taggable_type = publication_type AND " + condition).uniq
  # end
  #
  # def self.in_category(category_list)
  #   where{category_id.in(category_list)}
  # end

  def self.subscribed_by_user(user)
    user_condition = sanitize_sql_for_conditions(["feeds.user_id = ?", user.id])

    joins(
      <<-SQL
        INNER JOIN tags
        ON tags.taggable_id = publication_entries.publication_id AND
           tags.taggable_type = publication_entries.publication_type
        INNER JOIN feeds
        ON (feeds.tag_name IS NULL OR feeds.tag_name = tags.name) AND
           (feeds.kind IS NULL OR feeds.kind = publication_entries.publication_kind) AND
           (feeds.category_id IS NULL OR feeds.category_id = publication_entries.category_id) AND
           #{user_condition}
      SQL
    ).uniq
  end
end
