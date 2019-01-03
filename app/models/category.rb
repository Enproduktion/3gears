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

class Category < ActiveRecord::Base
  # Validations
  validates :name, presence: true

  # Scopes
  scope :for_movies_and_ideas, -> { where(category_type: "movie_or_idea") }
  scope :for_footage, -> { where(category_type: "footage") }
  scope :for_articles, -> { where(category_type: "article") }

  # 
  # Class methods
  # 
  class << self
    def get_map
      Hash[Category.all.map { |category| [category.id, category.name] }]
    end

    def for(collection)
      case collection
      when "movies", "ideas", "movies_and_ideas"
        Category.for_movies_and_ideas
      when "footage"
        Category.for_footage
      when "articles"
        Category.for_articles
      end
    end
  end
end
