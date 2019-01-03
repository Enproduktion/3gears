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

class OrganisationsController < ApplicationController
  authorize_resource
  load_and_authorize_resource except: [:clear, :confirm]

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def index
  end

  def create
    if Frontend.is_ava?
      create_organisation_ava
    else
      unless current_user.valid_password?(params[:organisation][:password])
        return redirect_to root_path, notice: I18n.t('organisation.wrong_password')
      end

      if @organisation.save
        redirect_to root_url, notice: I18n.t('organisation.created')
      end
    end
  end

  def confirm
    @organisation = Organisation.find_by_token(params[:confirmation_code])

    if @organisation.nil?
      redirect_to root_url, notice: I18n.t('organisation.not_found')
    else
      @organisation.confirmed = true
      @organisation.save!
      redirect_to root_url, notice: I18n.t('organisation.saved')
    end
  end

  def show
    @navigation_text = 'PROFILE'
    @movies_and_ideas = @organisation.movies_and_ideas.accessible_by(current_ability)
    render :edit
  end

  def edit
    @navigation_text = 'PROFILE'
    @editing_enabled = can?(:update, @user)
    @movies_and_ideas = @organisation.movies_and_ideas.accessible_by(current_ability)
  end

  def update
    if @organisation.update_attributes(update_params)
      @editing_enabled = can?(:update, @user)
      @movies_and_ideas = @organisation.movies_and_ideas.accessible_by(current_ability)
      render :edit
    else
      render_errors(@organisation, :unprocessable_entity)
    end
  end

  def destroy
    @organisation.destroy
    redirect_to root_url
  end

  def use
    session[:organisation] = @organisation.token
    redirect_to root_url, notice: "#{@organisation.name}"
  end

  def clear
    session[:organisation] = nil
    redirect_to root_url, notice: "#{current_user.username}"
  end

  private
  def create_params
    params.require(:organisation).permit(:name).merge(user: current_user)
  end

  def update_params
    params.require(:organisation).permit(:name, :avatar, :cover, :email, :abstract, :country, :zip, :city, :first_address, :second_address, :users)
  end

  def create_organisation_3gears
    @organisation.confirmed = true
    if @organisation.save
      redirect_to edit_organisation_path(@organisation)
    end
  end

  def create_organisation_ava
    @organisation.confirmed = true
    @organisation.user = current_user

    if @organisation.save
      redirect_to organisation_path(@organisation), notice: I18n.t('organisation.created')
      # redirect_to edit_organisation_path(@organisation)
    else
      redirect_to root_url, alert: I18n.t('organisation.creation_failed')
    end
  end
end
