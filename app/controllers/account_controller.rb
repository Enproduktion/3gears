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


class AccountController < ApplicationController
  authorize_resource class: false

  theme Frontend::APP_STYLE, only: [:new, :create, :confirm, :show] unless Frontend.is_empty_style?

  def new
    @nav = "navbar-3dox-no-transparent"
    @user = User.new
  end

  def create
    @user = User.new(create_params, as: :register)
    @user.role = 'guest'
    if @user.save
      AccountMailer.confirmation(@user).deliver_now
    else
      render action: :new
    end
  end

  # show detail user
  # 
  def show
    @user = current_user
  end

  # ---- unused method?
  def edit
    @user = current_user
  end

  # update detail user
  # can update language, first_name, and last_name
  # 
  def update
    @user = current_user

    if @user.update_attributes(permitted_params)
      render :show, layout: false
    else
      render_errors(@user, :unprocessable_entity)
    end
  end

  # account confirmation and auto login
  def confirm
    @user = User.find_using_perishable_token(params[:confirmation_code])

    if @user
      @user.confirmed = true
      @user.reset_perishable_token
      @user.save!

      UserSession.create(@user)
      redirect_to localized_root_path, notice: I18n.t('account.register.confirmation')
    end
  end

  private
  def create_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :password_confirmation, :email)
  end

  def permitted_params
    params.require(:user).permit(:language, :first_name, :last_name, :country)
  end

  def new_design_registration_flow
    if @user.save
      AccountMailer.confirmation(@user).deliver_now
      respond_to do |format|
        format.js { render js: "window.location.href='#{root_path}'" }
      end
    else
      render_errors(@user, :unprocessable_entity, true)
    end
  end
end
