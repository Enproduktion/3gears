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

module CreationsHelper
  def current_user_creations_path(type = :all)
    user_creations_path(current_user, type: type)
  end

  def path_to_creation(creation, type = "show")
    case creation
    when MovieOrIdea
      if creation.is_idea
        case type
        when "show"
          idea_path(creation)
        when "edit"
          edit_idea_path(creation)
        end
      else
        case type
        when "show"
          movie_path(creation)
        when "edit"
          edit_movie_path(creation)
        end
      end
    when Footage
      case type
      when "show"
        footage_path(creation)
      when "edit"
        edit_footage_path(creation)
      end
    else
      nil
    end
  end

  def path_to_edit_creation(creation)
    path_to_creation(creation, "edit")
  end

  def link_to_creations(label, args, enable_link = false)

    args.each do |arg, value|
      enable_link = true if value.to_s != params[arg].to_s
    end

    if enable_link
      args[:category] = nil if args.has_key?(:type) && !args.has_key?(:category)
      new_params = params.merge(args)

      if params[:user_id]
        link_to label.titleize, user_creations_path(new_params)
      else
        link_to label.titleize, creations_path(new_params)
      end
    else
      label
    end
  end

  def rescue_empty_footage_title(title)
    rescue_empty_title(title, 'footage')
  end

  def rescue_empty_idea_title(title)
    rescue_empty_title(title, 'idea')
  end

  def rescue_empty_movie_title(title)
    rescue_empty_title(title, 'movie')
  end

  def rescue_empty_title(title, type)
    if title.blank?
      case type
      when 'footage'
        t('footage.untitled')
      when 'movie'
        t('movie.untitled')
      when 'idea'
        t('idea.untitled')
      end
    else
      title
    end
  end
end
