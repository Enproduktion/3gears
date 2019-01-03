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

class UsersController < ApplicationController
  load_and_authorize_resource find_by: :username

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def index
    @navigation_text = 'USER'
  end

  def show
    @navigation_text = 'PROFILE'
    if Frontend::APP_STYLE.empty?
      @editing_enabled = can?(:update, @user)
    else
      @nav = 'navbar-3dox-no-transparent'
    end

    @ideas    = MovieOrIdea.accessible_by(current_ability).ideas.page(params[:idea_page]).per(1)
    @movies   = MovieOrIdea.accessible_by(current_ability).movies.page(params[:movie_page]).per(1)
    @footage  = Footage.accessible_by(current_ability).page(params[:footage_page]).per(1)
    @movies   = MovieOrIdea.where(user: @user).accessible_by(current_ability).movies
  end

  def edit
    @navigation_text = 'PROFILE'
    @editing_enabled = can?(:update, @user)
  end

  def update
    if @user.update_attributes(permitted_params)
      @editing_enabled = can?(:update, @user)
      if Frontend::APP_STYLE.empty?
        render :edit, layout: false
      else
        render :edit
      end
    else
      if params[:user][:password] || params[:user][:password_confirmation]
        @navigation_text = 'PROFILE'
        @editing_enabled = can?(:update, @user)
        render :edit
      else
        render_errors(@user, :unprocessable_entity)
      end
    end
  end

  def destroy
    unless params[:message].blank?
      AccountMailer.admin_delete(@user, params[:message]).deliver_now
    end

    @user.destroy
    redirect_to root_url
  end

  def suggest
    suggestions = User.autocomplete_suggestions(params[:term], 3).map do |user|
      {
        username: user.username,
        view: render_to_string(partial: "users/autocomplete", locals: { user: user }),
        selected_view: render_to_string(partial: "users/selected", locals: { user: user }),
      }
    end
    render json: suggestions.to_json
  end

  private

  def default_permitted_params
    [:avatar, :cover, :abstract, :field_of_work, :picture, :username, :first_name, :last_name, :abstract, :country, :zip, :city, :first_address, :second_address]
  end

  def admin_permitted_params
    [:avatar, :cover, :abstract, :field_of_work, :picture, :username, :first_name, :last_name, :abstract, :country, :zip, :city, :first_address, :second_address, :role]
  end

  def permitted_params
    allowed_user_params  = current_user.admin? ? admin_permitted_params : default_permitted_params
    allowed_user_params += [:password, :password_confirmation] if @user.id == current_user.id
    params.require(:user).permit(*allowed_user_params)
  end
end
