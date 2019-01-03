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

class AccountPasswordController < ApplicationController
  authorize_resource class: false

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    unless @user.valid_password?(params[:user][:password])
      @user.errors.add(:password, I18n.t("error_messages.password_invalid"))
    end

    if params[:user][:new_password].blank? || params[:user][:password_confirmation].blank?
      @user.errors.add(:new_password, I18n.t("errors.messages.blank"))
    end

    unless @user.errors.empty?
      render :edit
      return
    end

    @user.password = params[:user][:new_password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
    unless @user.save
      render :edit
    end
  end
end
