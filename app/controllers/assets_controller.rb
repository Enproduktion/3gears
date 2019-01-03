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

class AssetsController < ApplicationController
  before_filter { params[:id] ||= params[:asset_id] }
  load_and_authorize_resource :article
  load_and_authorize_resource :asset, through: :article

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def new
  end

  # Create asset
  # @asset is created from load_and_authorize_resource :asset, through: :article
  # this will load 'create_params' private method
  # for passing protected parameters
  # 
  def create
    if @asset.save
      respond_to do |format|
        format.html { redirect_to @article }
        format.json { head :created }
      end
    else
      render action: :new
    end
  end

  # delete an asset
  # 
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to @article }
      format.json { head :ok }
    end
  end

  # move_up
  # set asset for cover image
  # 
  def move_up
    @asset.move_higher
    @asset.save!
    head :ok
  end

  # move down
  # set asset to down if you don't want
  # selected asset to be cover image
  # 
  def move_down
    @asset.move_lower
    @asset.save!
    head :ok
  end

  private
  def create_params
    params.require(:asset).permit(:content, :article)
  end
end
