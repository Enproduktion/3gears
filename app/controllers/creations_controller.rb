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

class CreationsController < ApplicationController
  include CreationsHelper

  load_and_authorize_resource :user, find_by: :username

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def index
    @nav = 'navbar-3dox'
    show_article_slider true
    
    # Get Articles
    @articles = Article.get_articles(current_ability)

    get_creations

    if is_not_3gears?
      @creations = MovieOrIdea.accessible_by(current_ability).from_user(@user) +
                   Footage.accessible_by(current_ability).from_user(@user)
    end

    if params[:type] != 'all'
      sort_creations
      paginate_creations
    end

    @show_create_links = current_user && (!@user || @user == current_user)
  end

  def create
    object = creations_type
    if object.save
      render json: path_to_creation(object)
    else
      render_errors(object, :unprocessable_entity)
    end
  end

  helper_method :showing_ideas?, :showing_movies?, :showing_footage?

  private
  def is_not_3gears?
    params[:type] == 'all'&& @user
  end

  def showing_ideas?
    params[:type] == "all" || params[:type] == "ideas"
  end

  def showing_movies?
    params[:type] == "all" || params[:type] == "movies"
  end

  def showing_footage?
    params[:type] == "all" || params[:type] == "footage"
  end

  def creations_type
    case params[:type]
    when '1'
      Footage.new(user: current_user)
    when '2'
      MovieOrIdea.new(is_idea: false, user: current_user)
    when '3'
      MovieOrIdea.new(is_idea: true, user: current_user)
    end
  end

  def get_creations
    case params[:type]
    when "movies"
      get_movies_or_ideas_creations('MOVIE', 'movies')
    when "ideas"
      get_movies_or_ideas_creations('IDEA', 'ideas')
    when "footage"
      @navigation_text = 'FOOTAGE'
      @creations = Footage.accessible_by(current_ability).includes(:user, :organisation)
    when "all"
      @navigation_text = 'BROWSE'
      @user.nil? ? item_list : user_item_list
      paginate_item_list
    end
    if @user and params[:type] != "all"
      @creations = @creations.from_user(@user)
    end
  end

  def get_movies_or_ideas_creations(navigation_text, scope)
    @navigation_text = navigation_text
    @creations = MovieOrIdea.get_creations(scope, current_ability)
  end

  def sort_creations
    @creations.is_a?(Array) ? sort_creations_array : sort_creations_object
  end

  def sort_creations_array
    @creations.sort_by! do |creation|
      case params[:first]
      when "most_viewed"
        - creation.view_count
      when "least_viewed"
        creation.view_count
      when "oldest"
        creation.created_at
      else
        - creation.created_at.to_i
      end
    end
  end

  def sort_creations_object
    case params[:first]
    when "most_viewed"
      @creations = @creations.order("view_count DESC")
    when "least_viewed"
      @creations = @creations.order("view_count")
    when "most_liked"
      @creations = @creations.order("likes_count")
    when "oldest"
      @creations = @creations.order("created_at")
    else
      @creations = @creations.order("created_at DESC")
    end
  end

  def paginate_creations
    if !@creations.is_a?(Array)
      @categories = Category.for(params[:type])
      @creations = @creations.from_category(params[:category]) if params[:category]
    end

    if @creations.is_a?(Array)
      @creations = Kaminari.paginate_array(@creations)
    end

    @creations = @creations.page(params[:page]).per(2)
  end

  def item_list
    @movies  = MovieOrIdea.accessible_by(current_ability).movies
    @ideas   = MovieOrIdea.accessible_by(current_ability).ideas
    @footage = Footage.accessible_by(current_ability)
  end

  def user_item_list
    item_list
    @movies  = @movies.from_user(@user)
    @ideas   = @ideas.from_user(@user)
    @footage = @footage.from_user(@user)
  end

  def paginate_item_list
    @movies  = @movies.page(params[:movie_page]).per(2)
    @ideas   = @ideas.page(params[:idea_page]).per(2)
    @footage = @footage.page(params[:footage_page]).per(2)
  end
end
