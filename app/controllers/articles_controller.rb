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

class ArticlesController < ApplicationController
  load_and_authorize_resource

  theme Frontend::APP_STYLE, only: [:show, :index, :update] unless Frontend.is_empty_style?

  def index
    @navigation_text = 'ARTICLES'
    @articles = @articles.only_with_locale(["en", I18n.locale]) unless can?(:manage, Article)
    @articles = @articles.page(params[:page])
  end

  # show an article
  # automaticly increase view count
  # 
  def show
    @nav_3gears = 'navigation-transparent'
    @nav = "navbar-3dox-no-transparent"
    @navigation_text = 'ARTICLES'
    @article.increase_view_count
    @editing_enabled = can?(:update, @article)
    @editable_locales = Rails.application.config.supported_locales

    @assets = @editing_enabled ? @article.assets : @article.secondary_images

    # only show if not in edit mode
    if !@editing_enabled
      @random_article = Article
        .accessible_by(current_ability)
        .where("articles.id != ?", @article.id)
        .order("RAND()")

      @recent_articles = Article
        .accessible_by(current_ability)
        .where("articles.id != ?", @article.id)
        .newest_first
    end
  end

  # create new article
  # 
  def new
    @article.user = current_user
    @article.content(I18n.default_locale).title = t 'articles.untitled'
    @article.save!
    redirect_to @article
  end

  # change article status
  # published: true or false
  def update
    if @article.update_attributes(update_params)
      @article.user = current_user if @article.user_id.nil?
      @editing_enabled = true
      @editable_locales = []
      @assets = []
      redirect_to @article
    else
      render_errors(@article, :unprocessable_entity)
    end
  end

  # delete an article
  # 
  def destroy
    @article.destroy
    flash[:success] = 'Article successfully deleted'
    redirect_to articles_path
  end

  private
  # Protected params
  def update_params
    params.require(:article).permit(:view, :viewable_by_all)
  end
end
