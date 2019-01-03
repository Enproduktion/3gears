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

class FootageController < ApplicationController
  before_filter { params[:id] ||= params[:footage_id] }
  load_and_authorize_resource except: [:add_to_movie, :remove_from_movie]
  load_resource only: [:add_to_movie, :remove_from_movie]

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def new
    if current_organisation
      @footage.is_organisation = true
      @footage.organisation = current_organisation
    else
      @footage.user = current_user
    end

    if params[:movie_id].present?
      authorize!(:read, @footage)

      @movie_or_idea = MovieOrIdea.find(params[:movie_id])
      authorize!(:update, @movie_or_idea)

      unless @movie_or_idea.footage.exists?(@footage.id)
        @movie_or_idea.footage << @footage
        @movie_or_idea.save!
      end
    end

    @footage.save!
    redirect_to footage_path(@footage)
  end

  def show
    @navigation_text = 'FOOTAGE'
    @nav_3gears = 'navigation-transparent'
    @nav = "navbar-3dox"
    @footage.increase_view_count
    @editing_enabled = can?(:update, @footage)
    @movies_and_ideas = @footage.movies_and_ideas.accessible_by(current_ability)

    @initialAnnotationId = params[:annotation_id]

    @footage.footage_metadatum = FootageMetadatum.create if @footage.footage_metadatum.nil?

    @similar_from_user = Footage
      .accessible_by(current_ability)
      .where("id != ?", @footage.id)
      .first_in_category(@footage.category)
      .recently_published_first

    @popular_in_same_category = @footage.search_in_same_category
      .accessible_by(current_ability)
      .where("id != ?", @footage.id)
      .popular_first

    @random_with_thumbnail = Footage
      .accessible_by(current_ability)
      .only_with_medium_thumbnail
      .where("footage.id != ?", @footage.id)
      .order("RAND()")

    @used_in_movies = @footage.movies_and_ideas.movies
      .accessible_by(current_ability)
      .recently_published_first

    respond_to do |format|
      format.html
      format.rdfa
      format.jsonld
    end
  end

  def edit
    @navigation_text = 'FOOTAGE'
    @nav = 'navbar-3dox-no-transparent'
    @editing_enabled = can?(:update, @footage)
  end

  def update
    if @footage.update(permitted_params)
      success_flash = t 'footage.update_success'
    else
      alert_flash = @footage.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.html {
        flash[:success] = success_flash if success_flash != nil
        flash[:alert] = alert_flash if alert_flash != nil
        redirect_to @footage
      }
      format.json {render json: @footage}
    end
  end

  def destroy
    @footage.destroy
    if Frontend::APP_STYLE.empty?
      head :ok
    else
      redirect_to root_url, notice: I18n.t('footage.delete_successful')
    end
  end

  def add_to_movie
    authorize!(:read, @footage)

    @movie_or_idea = MovieOrIdea.find(params[:movie_id])
    authorize!(:update, @movie_or_idea)

    unless @movie_or_idea.footage.exists?(@footage.id)
      @movie_or_idea.footage << @footage
      @movie_or_idea.save!
    end
    head :ok
  end

  def remove_from_movie
    @movie_or_idea = MovieOrIdea.find(params[:movie_id])
    authorize!(:update, @movie_or_idea)

    @movie_or_idea.footage.delete(@footage)
    head :ok
  end

  private
  def permitted_params
    params.require(:footage).permit(:category_id, :viewable_by_all, :published, :title, :abstract, :caption, :synopsis,
     :analog, :camera, :lense, :focal_distance, :color, :ratio, :audio_recorder, :audio_mixer, :microphone, movie_or_idea_ids: [])
  end

  def owner_item
    if @footage.is_organisation?
      @footage.organisation == current_organisation
    else
      @footage.user == current_user
    end
  end
end
