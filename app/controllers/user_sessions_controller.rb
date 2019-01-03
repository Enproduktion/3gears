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

class UserSessionsController < ApplicationController
  authorize_resource class: false

  def new
    @user_session = UserSession.new
    @redirect_to = localized_root_path
  end

  def create
    @redirect_to = session[:redirect_to] || localized_root_path

    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      session[:login_success] = true
      if Frontend::APP_STYLE.empty?
        session[:redirect_to] = nil
        redirect_to @redirect_to
      else
        # redirect_to @redirect_to
        redirect_path = localized_root_path
        respond_to do |format|
          format.html { redirect_to redirect_path }
          format.js { render js: "window.location = '#{redirect_path}'" }
        end
      end
    else
      if Frontend::APP_STYLE.empty?
        render :action => :new
      else
        redirect_to localized_root_path, flash: { error: t('error_messages.invalid_login_password_combination') }
      end
    end
  end

  def update
    act_as_organisation = params[:organisation_token]
    if !act_as_organisation || act_as_organisation && current_user.user_organisations.joins(:organisation).references(:organisation).where(organisations: {token: act_as_organisation}).exists?
      session[:organisation] = act_as_organisation
    end
    redirect_to localized_root_path
  end

  def destroy
    session[:organisation] = nil
    current_user_session.try :destroy
    redirect_to localized_root_path
  end
end
