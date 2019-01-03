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

class NotificationsController < ApplicationController
  load_and_authorize_resource

  # show notification index
  def index
    @notifications = @notifications.newest_first.page(params[:page])
  end

  # update readed notification
  def update
    if @notification.update_attributes(params[:notification])
      head :ok
    else
      render_errors(@notification, :unprocessable_entity)
    end
  end

  private
  def update_params
    params.require(:notification).permit(:unread)
  end
end
