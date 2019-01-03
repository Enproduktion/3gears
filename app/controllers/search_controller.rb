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

class SearchController < ApplicationController
  authorize_resource class: false

  # storyteller / search
  # return movies, ideas, footage, articles and users
  # required params:
  #   params[:q] - default ''
  # optional:
  #   params[:kind] - 'users'
  #                 - ideas, footage, movies ..
  #

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Search for footage
  def show
    raise ArgumentError.new('You can only search for footage for now') if params[:type] != 'footage'

    @query                  = params[:q] || ''
    @query_without_years    = @query.gsub(/\d{4}/, '').strip
    @tag_filters            = params[:tags] || []
    @search_filters         = params[:filters] || []

    @with_movie_or_idea_ids = []
    @with_tag_ids           = []
    @with_years             = @query.scan /\d{4}/ # all four digit text is treated as a single year
    
    @search_filters = @search_filters.split(',').map do |filter_str|
      filter = filter_str.split('_')
      if filter[0] == 'collections'
        m = MovieOrIdea.find(filter[1])
        @with_movie_or_idea_ids << m.id
        {id: m.id, type: 'collections', title: m.title}
      elsif filter[0] == 'tags'
        t = Tag.find(filter[1])
        @with_tag_ids << t.id
        {id: t.id, type: 'tags', title: t.name}
      elsif filter[0] == 'year-range'
        years = filter[1].split('-')
        year_min = years[0]
        year_max = years[1]
        @with_years += (year_min..year_max).to_a
        {id: filter[1], type: 'year-range', title: filter[1]}
      end
    end.compact

    if @with_years.any?
      tag_ids = Tag.where(name: @with_years).pluck(:id)
      @with_tag_ids += tag_ids
    end

    with_all = {}
    with_all[:movie_or_idea_ids] = @with_movie_or_idea_ids if @with_movie_or_idea_ids.any?
    #with_all[:tag_ids] = @with_tag_ids if @with_tag_ids.any?
    with_all[:media_time_tag_tag_ids] = [@with_tag_ids] if @with_tag_ids.any?
    #with_all[:tagged_years] = [@with_years] if @with_years

    sql         = Footage.accessible_by(current_ability).select(:id).to_sql
    footage_ids = Footage.connection.select_values sql

    search_options = {
      with_all: with_all,
      order: :date,
      sort_mode: :desc,
      with: {:sphinx_internal_id => footage_ids}
    }

    if footage_ids.empty? || (@query != @query_without_years && @with_tag_ids.empty? && @with_movie_or_idea_ids.empty?)
      @results = []
    else
      @results = Footage.search(ThinkingSphinx::Query.wildcard(ThinkingSphinx::Query.escape(@query_without_years)), search_options).page(params[:page])
    end

    @originals = @results.map &:original

    if @with_tag_ids && @originals
      @footage_media_time_tags = {}
      @media_time_tags = MediumTimeTag
                           .joins(:tag, :medium)
                           .references(:tag, :medium)
                           .includes(:tag, :medium)
                           .where(tags: {id: @with_tag_ids})
                           .where(medium: @originals)

      @results.each do |footage|
        @footage_media_time_tags[footage.id] = @media_time_tags.select{|mtt| mtt.medium == footage.original}.to_a
      end
    end
  end
  
  def quick_search
    quick_search = QuickSearchCommand.new(query: params[:q], current_ability: current_ability)
    render json: quick_search.results.to_json
  end
end
