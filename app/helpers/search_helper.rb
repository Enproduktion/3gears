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

module SearchHelper
  def link_to_search(label, args)
    enable_link = false

    args.each do |arg, value|
      enable_link = true if value.to_s != params[arg].to_s
    end

    if enable_link
      args[:category] = nil if args.has_key?(:kind) && !args.has_key?(:category)
      new_params = params.merge(args)

      link_to label, search_path(new_params)
    else
      label
    end
  end

  def similar_search_path(object)
    q = object.tags.map(&:name).join(" ")

    case object
    when MovieOrIdea
      search_path(
        kind: object.is_idea ? "ideas" : "movies",
        category: object.category_id,
        q: q,
      )
    when Footage
      search_path(
        kind: "footage",
        category: object.category_id,
        q: q,
      )
    when User
      search_path(
        kind: "users",
#        occupation: object.occupation, TODO
        q: q,
      )
    when Article
      search_path(
        kind: "articles",
        category: object.category_id,
        q: q,
      )
    end
  end

  def tag_search_path(tag)
    taggable = tag.taggable
    case taggable
    when MovieOrIdea
      search_path(
        kind: taggable.is_idea ? "ideas" : "movies",
        category: taggable.category_id,
        q: tag.name,
      )
    when Footage
      search_path(
        kind: "footage",
        category: taggable.category_id,
        q: tag.name,
      )
    when Article
      search_path(kind: "articles", q: tag.name)
    else
      search_path(q: tag.name)
    end
  end
end
