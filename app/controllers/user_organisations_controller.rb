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

class UserOrganisationsController < ApplicationController

  load_and_authorize_resource

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  def create
    @user_organisation = UserOrganisation.find_or_create_by(create_params)
    if @user_organisation.valid?
      if params[:render_partial]
        render partial: "organisation_members/organisation_member_list", locals: { editable: true, organisation: @user_organisation.organisation}
      else
        redirect_to @user_organisation.organisation
      end
    else
      render text: t('user.not_found'), status: :unprocessable_entity
    end
  end

  def destroy
    @user_organisation.destroy
    head :ok
  end

  private
  def create_params
    params.require(:user_organisation).permit(:organisation_id).merge(user: user_params)
  end

  def user_params
    User.find_by_username(params[:username])
  end

end
