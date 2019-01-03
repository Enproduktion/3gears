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

class TagReferencesController < ApplicationController
  include HasPolymorphicParent
  before_filter { @taggable = find_polymorphic_parent }

  authorize_resource :taggable
  load_and_authorize_resource through: :taggable

  # manual authorization
  skip_load_and_authorize_resource only: :destroy

  def create
    if @tag_reference.save
      render json: @tag_reference, status: :created
    else
      render_errors(@tag_reference, :unprocessable_entity)
    end
  end

  def update
    if @tag_reference.update_attributes(update_params)
      render json: @tag_reference, status: :ok
    else
      render_errors(@tag_reference, :unprocessable_entity)
    end
  end

  def destroy
    @tag = @taggable.tags.where(name: params[:id]).first
    @tag_reference = @taggable.tag_references.where(tag: @tag).first

    authorize! :destroy, @tag_reference
    if @tag_reference.destroy
      # delete tag if it has no longer any tag_references
      @tag.destroy if @tag.tag_references.count == 0
      render json: 1, status: :ok
    else
      render_errors(@tag_reference, :unprocessable_entity)
    end

  end

  private

  def create_params
    params.require(:tag).permit(:name)
  end

  def update_params
    params.require(:tag).permit(:name)
  end

end
