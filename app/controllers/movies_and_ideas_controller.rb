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

class MoviesAndIdeasController < ApplicationController
  include CreationsHelper

  before_filter { params[:id] ||= params[:idea_id] || params[:movie_or_idea_id] }
  load_and_authorize_resource :movie_or_idea, parent: false

  theme Frontend::APP_STYLE, only: [:show, :edit, :update] unless Frontend.is_empty_style?

  def new
    @movie_or_idea.is_idea = params[:as_idea]

    if current_organisation
      @movie_or_idea.is_organisation = true
      @movie_or_idea.organisation = current_organisation
    else
      @movie_or_idea.user = current_user
      @movie_or_idea.organisation_id = params[:organisation_id]
    end

    @movie_or_idea.save!
    redirect_to path_to_creation(@movie_or_idea)
  end

  def show
    @navigation_text = @movie_or_idea.is_idea? ? 'IDEA' : 'MOVIE'
    @nav_3gears = 'navigation-transparent'
    @nav = 'navbar-3dox'
    @footages = @movie_or_idea.footage.accessible_by(current_ability)
    @movie_or_idea.increase_view_count
    redirect_to path_to_creation(@movie_or_idea) if @movie_or_idea.is_idea != params[:as_idea]

    @first_footage = @movie_or_idea.footage.accessible_by(current_ability).first

    @editing_enabled = can?(:update, @movie_or_idea)

    similar_from_user
    popular_in_same_category
    movie_or_idea_random
  end

  def edit
    @navigation_text = @movie_or_idea.is_idea? ? 'IDEA' : 'MOVIE'
    @nav = 'navbar-3dox-no-transparent'
    @editing_enabled = can?(:update, @movie_or_idea)
  end

  def update
    if @movie_or_idea.update(permitted_params)
      success_flash = t 'movie_or_idea.update_success'
    else
      alert_flash = @movie_or_idea.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.html {
        flash[:succes] = success_flash if success_flash != nil
        flash[:alert] = alert_flash if alert_flash != nil
        redirect_to @movie_or_idea
      }
      format.json {render json: @movie_or_idea}
    end
  end

  def destroy
    @movie_or_idea.destroy
    redirect_to root_url, notice: I18n.t('movie.delete_successful')
  end

  def delete_script
    @movie_or_idea.script.destroy
    head :ok
  end

  def finalize
  end

  def make_movie
    @movie_or_idea.is_idea = false
    @movie_or_idea.save
    redirect_to path_to_creation(@movie_or_idea)
  end

  private
  def permitted_params
    params.require(:movie_or_idea).permit(:category_id, :viewable_by_all, :script, :published, :title,
     :abstract, :budget_needed, :budget_raised, :budget_desc, :synopsis)
  end

  def similar_from_user
    @similar_from_user = (@movie_or_idea.is_idea ? MovieOrIdea.ideas : MovieOrIdea.movies)
      .accessible_by(current_ability)
      .where("id != ?", @movie_or_idea.id)
      .first_in_category(@movie_or_idea.category)
      .recently_published_first
  end

  def popular_in_same_category
    @popular_in_same_category = @movie_or_idea.search_in_same_category
      .accessible_by(current_ability)
      .where("id != ?", @movie_or_idea.id)
      .popular_first
  end

  def movie_or_idea_random
    if @movie_or_idea.is_idea
      @random_with_title = MovieOrIdea.ideas
        .accessible_by(current_ability)
        .where("title != ''")
        .where("movies_and_ideas.id != ?", @movie_or_idea.id)
        .order("RAND()")
    else
      @random_with_thumbnail = MovieOrIdea.movies
        .accessible_by(current_ability)
        .where("movies_and_ideas.id != ?", @movie_or_idea.id)
        .order("RAND()")

      @used_footage = @movie_or_idea.footage
        .accessible_by(current_ability)
        .recently_published_first
    end
  end

  def owner_item
    if @movie_or_idea.is_organisation?
      @movie_or_idea.organisation == current_organisation
    else
      @movie_or_idea.user == current_user
    end
  end
end
