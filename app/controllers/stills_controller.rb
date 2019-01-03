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

class StillsController < ApplicationController
  load_and_authorize_resource :movie_or_idea
  load_and_authorize_resource :still, through: :movie_or_idea

  layout 'iframe'

  def index
    @editing_enabled = can?(:update, Still)
  end

  # will create still
  # this will load 'create_params' private method
  # for pass protected parameters
  # 
  def create

    @still.save

    errors = @still.errors.full_messages

    respond_to do |format|
      format.html {
        flash[:success] = t('still.create_success') if errors.empty?
        flash[:alert] = errors.to_sentence unless errors.empty?
        redirect_to action: 'index'
      }
      format.json {render json: @still, status: :created}
    end
  end

  # Update still
  # @still is created from load_and_authorize_resource :still, through: :movie_or_idea
  # 
  def update
    if @still.update_attributes(update_params)
      alert_flash = @still.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.html {
        flash[:alert] = alert_flash if alert_flash != nil
        redirect_to action: 'index'
      }
      format.json {render json: @still}
    end
  end

  # Delete still
  # 
  # 
  def destroy
    if @still.destroy
      redirect_to action: 'index'
    else
      render_errors @still, :unprocessable_entity
    end
  end

  private
  # this will pass protected parameters for create method
  # upload still image without title and abstract
  # title and abstract can be change from update method
  # 
  def create_params
    params.require(:still).permit(:content, :title, :abstract)
  end

  # this will pas protected parameters for update method
  # still image can't change with update parameters
  # 
  def update_params
    params.require(:still).permit(:title, :abstract)
  end
end
