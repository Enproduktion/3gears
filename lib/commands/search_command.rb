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

class SearchCommand
  def initialize params={}
    @query    = params[:query]
    @kind     = params[:kind]
    @category = params[:category]

    @results =
      case @kind
      when "movies"
        klass = MovieOrIdea
        with = { is_idea: false }
      when "ideas"
        klass = MovieOrIdea
        with = { is_idea: true }
      when "footage"
        klass = Footage
        with = {}
      when "articles"
        klass = Article
        with = {}
      when "users"
        klass = User
        with = {}
      else
        klass = ThinkingSphinx
        with = {}
      end

    with[:category_id] = @category.id if @category

    search_options = {
      with: with,
      order: :date,
      sort_mode: :desc,
    }

    @results = klass.search(ThinkingSphinx::Query.wildcard(ThinkingSphinx::Query.escape(@query)), search_options).page(params[:page])
    @results = @results.group_by(&:class)
  end

  def results
    @results
  end
end
