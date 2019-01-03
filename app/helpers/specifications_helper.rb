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

module SpecificationsHelper
  def link_to_spec(model, locale = params[:locale])
    case model.class.name
    when "MovieOrIdea"
      movie_or_idea_specifications_path(locale: locale, movie_or_idea_id: model)
    when "Footage"
      footage_specifications_path(locale: locale, footage_id: model)
    end
  end
end
