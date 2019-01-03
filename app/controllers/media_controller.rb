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

class MediaController < ApplicationController
  before_filter { params[:id] ||= params[:medium_id] }
  load_and_authorize_resource :medium

  def status
    render json: { status: @medium.get_status() }
  end

  def destroy
    @medium.destroy
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to @medium.referer || root_url, notice: I18n.t('medium.delete_successful') }
    end
  end

  def pick_thumbnail
    @medium.pick_random_thumbnail
    head :ok
  end
end
