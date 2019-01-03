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

class CommentsController < ApplicationController
  include HasPolymorphicParent
  before_filter { @commentable = find_polymorphic_parent }
  authorize_resource :commentable
  load_and_authorize_resource :comment, through: :commentable

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Create comment
  # @comment is created from load_and_authorize_resource :comment, through: :commentable
  # this will load 'create_params' private method
  # for passing protected parameters
  # 
  def create
    @comment.user = current_user

    if @comment.save
      if request.xhr?
        render json: @commentable.comments, root: false, status: 201
      else
        render @comment, locals: { commentable: @commentable }, status: 201
      end
    else
      render_errors(@comment, :unprocessable_entity)
    end
  end

  # delete comment
  # from movie, idea or footage
  def destroy
    @comment.destroy
    head :ok
  end

  private
  def create_params
    params.require(:comment).permit(:content, :comment_id)
  end
end
