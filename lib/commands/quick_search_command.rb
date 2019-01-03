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

class QuickSearchCommand
  def initialize params={}
    current_ability = params[:current_ability]
    @query = params[:query]
    @users = User.quick_search(@query)
    @tags  = Tag.quick_search(@query, current_ability)
    @footage  = Footage.quick_search(@query)
    @movie = MovieOrIdea.quick_search(@query, false)
    @idea  = MovieOrIdea.quick_search(@query, true)
    @organisation = Organisation.quick_search(@query)

    @results = {collections: @movie, tags: @tags, organizations: @organisation}
  end

  def results
    @results
  end
end
