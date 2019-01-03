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

class FrontpageController < ApplicationController

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def index

    @nav = "navbar-3dox"
    show_article_slider true

    @article  = Article.only_viewable_by_all.last
    @ideas    = MovieOrIdea.accessible_by(current_ability).ideas.includes(:user).page(params[:idea_page]).per(2)

    get_movies_context

    @footage  = Footage.accessible_by(current_ability).includes(:user).page(params[:footage_page]).per(2)
    @users = User
      .accessible_by(current_ability)
      .newest_first

    # @articles contains all currently visible articles sorted by publishing date desc
    if @article && @article.cover_image
      @header_image = @article.cover_image.content
    end
  end

  private

  def get_movies_context
    movies_on_page = 9
    @current_page = params[:movie_page] ? params[:movie_page].to_i : 1
    next_page = @current_page + 1
    movies = MovieOrIdea.accessible_by(current_ability)
    @total_pages = ( (movies.count / movies_on_page.to_f) % 1 ) > 0 ? ( movies.count / movies_on_page ) + 1 : ( movies.count / movies_on_page )
    @movies = movies.page(@current_page).per(movies_on_page)
    @next_movie_page = next_page <= @total_pages ? next_page : nil
    @last_movie_page = (@current_page - 1).to_i > 0 ? @current_page - 1 : nil

    # TODO: quick fix - calculation of total pages needs to be fixed
    @total_pages += 1 if @total_pages == 0

    redirect_to localized_root_path if @current_page > @total_pages
  end
end
