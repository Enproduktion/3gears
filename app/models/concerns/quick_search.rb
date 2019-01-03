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

module QuickSearch

  extend ActiveSupport::Concern

  module ClassMethods

    def autocomplete_suggestions(term, limit)
      self.search(wildcard_and_escape_query(term), max_mathces: limit, match_mode: :any)
    end

    def default_quick_search(query, options = {})
      objects = case self.to_s
                when Tag.to_s
                  self.autocomplete_suggestions(query, 4, options)
                else
                  !options[:is_idea].nil? ? self.autocomplete_suggestions(query, 4, options[:is_idea]) : self.autocomplete_suggestions(query, 4)
                end
      return [] if objects.empty?
      self.build_quick_search(objects, options[:url], options[:field], options[:title])
    end

    # 
    # Build quick search
    # 
    # sources = collection of object
    # url = url helper name
    # attribute_to_show = attribute to show on quick search, eg: title
    # text_title = collection name?
    # 
    def build_quick_search(sources, url_path, attribute_to_show, text_title)
      is_tag = false
      is_tag = true if self.name.to_s == "Tag"
      data = sources.map do |source|
        if is_tag
          link = Rails.application.routes.url_helpers.send(url_path, :en, q: source.name)
        else 
          link = Rails.application.routes.url_helpers.send(url_path, :en, source)
        end
        [{id: source.id, title: source.send(attribute_to_show), url: link}]
      end
      data.flatten!
      return data
    end

    private
    def wildcard_and_escape_query(query)
      wildcard_query(escape_query(query))
    end

    def wildcard_query(query)
      ThinkingSphinx::Query.wildcard(query)
    end

    def escape_query(query)
      ThinkingSphinx::Query.escape(query)
    end
  end
end
