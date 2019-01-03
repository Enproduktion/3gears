# Copyright (C) 2017 Enproduktion GmbH

# This file is part of 3gears.

# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module ApplicationHelper
  def supported_locales
    Rails.application.config.supported_locales
  end

  def body_class
    (params[:controller] + " " + params[:action] + "-action").gsub(/\//, '-')
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def translate_select_choices(choices, scope, group_scope = nil)
    choices.map do |category|
      [
        group_scope ? t(category[0], scope: group_scope) : category[0],
        category[1].map do |entry|
          [I18n.t(entry, scope: scope), entry]
        end
      ]
    end
  end

  def link_to_update_object(model)
    case model.class.name
    when "MovieOrIdea"
      movie_or_idea_path(model)
    when "Footage"
      footage_path(model)
    end
  end
end
