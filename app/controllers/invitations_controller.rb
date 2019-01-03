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

class InvitationsController < ApplicationController
  authorize_resource class: false

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  before_filter :new_invitation_object, only: [:new]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, notice: "You must logged in as admin"
  end

  def new
  end

  def create
    if Invitation.invite_person(create_params[:email], locale)
      redirect_to new_invitation_path, notice: "#{create_params[:email]} invited!"
    end
  end

  private
  def new_invitation_object
    @invitation = Invitation.new
  end

  def create_params
    params.require(:invitation).permit(:email)
  end
end
