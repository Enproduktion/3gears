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

class MediumTimeTagsController < ApplicationController
  load_and_authorize_resource :medium
  load_and_authorize_resource through: :medium

  skip_authorize_resource only: :index

  def index
    render json: @medium.medium_time_tags.includes(:tag)
  end

  def create
    if @medium_time_tag.save
      render json: @medium_time_tag, status: :created
    else
      render_errors(@medium_time_tag, :unprocessable_entity)
    end
  end

  def update
    if @medium_time_tag.update_attributes(update_params)
      render json: @medium_time_tag, status: :ok
    else
      render_errors(@medium_time_tag, :unprocessable_entity)
    end
  end

  def destroy
    if @medium_time_tag.destroy
      render json: 1, status: :ok
    else
      render_errors(@medium_time_tag, :unprocessable_entity)
    end
  end

  private

  def create_params
    params.require(:medium_time_tag).permit(:tag_name, :start_time, :end_time, :text)
  end

  def update_params
    create_params
  end

end
