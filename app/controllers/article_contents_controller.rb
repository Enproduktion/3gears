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

class ArticleContentsController < ApplicationController
  # load_and_authorize_resource
  # you can take a look at gem "cancancan"
  # https://github.com/CanCanCommunity/cancancan/wiki/
  # Nested Resource
  load_and_authorize_resource
  load_and_authorize_resource :article

  # Update article content
  # article content has locale en and de
  # 
  def update
    @article_content = @article.content(params[:content_locale])

    if @article_content.update_attributes(update_params)
      respond_to do |format|
        # format.html { redirect_to article_path(@article)}
        format.json { render json: @article_content }
      end
    else
      render_errors(@article_content, :unprocessable_entity)
    end
  end

  private
  # Protected params
  def update_params
    params.require(:article_content).permit(:title, :abstract, :body)
  end
end
