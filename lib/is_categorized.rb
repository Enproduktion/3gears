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

module IsCategorized
  extend ActiveSupport::Concern

  included do
    belongs_to :category
  end

  def search_in_same_category
    self.class.where(category_id: category_id)
  end

  def category_id=(category_id)
    super(category_id) if Category.exists?(category_id)
  end

  module ClassMethods
    def from_category(name)
      joins(:category).where("categories.name = ?", name)
    end

    def in_category(category)
      where(category_id: category.try(:id))
    end

    def not_in_category(category)
      if category
        where("category_id IS NULL OR category_id != ?", category.id)
      else
        where("category_id IS NOT NULL")
      end
    end

    def first_in_category(category)
      if category
        condition = sanitize_sql_for_conditions(["category_id = ? DESC", category.id])
        order(condition)
      else
        order("category_id IS NULL DESC")
      end
    end
  end
end
