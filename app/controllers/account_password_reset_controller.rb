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


class AccountPasswordResetController < ApplicationController
  authorize_resource class: false

  def new
    @user = User.new
  end

  def create
    if params[:user][:login].blank?
      @user = User.new
      @user.errors.add(:login, t("errors.messages.blank"))
      render :new
      return
    end

    @user = User.find_by_username_or_email(params[:user][:login])

    unless @user
      @user = User.new
      @user.errors.add(:login, t("user.not_found"))
      render :new
      return
    end

    AccountMailer.password_reset(@user).deliver_now
  end

  def edit
    @user = User.find_using_perishable_token(params[:confirmation_code])
  end

  def update
    @user = User.find_using_perishable_token(params[:confirmation_code])

    return render :edit unless @user

    if params[:user][:password].blank?
      @user.errors.add(:password, t("errors.messages.blank"))
      render :edit
      return
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.reset_perishable_token

    render :edit unless @user.save_without_session_maintenance
  end

  def recover
    @user = User.where(email: params[:user][:email]).first
    
    unless @user.nil?
      password = SecureRandom.base64(8)
      @user.password = password
      @user.password_confirmation = password
      @user.save_without_session_maintenance
      AccountMailer.recover_password(@user, password).deliver_now
    end

    redirect_to root_url
  end
end
