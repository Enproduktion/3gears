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

class LicensesController < ApplicationController
  load_and_authorize_resource :license

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Update license
  # 
  def update
    if @license.update_attributes(permitted_params)
      if Frontend::is_empty_style?
        render partial: "licenses/license", object: @license, locals: { editable: true }
      else
        case decide_template
        when "edit"
          render partial: "licenses/license_edit", object: @license, locals: { license: @license, editable: true }
        else
          render partial: "licenses/license", object: @license, locals: { license: @license, editable: true }
        end
      end
    else
      render_errors(@license, :unprocessable_entity)
    end
  end

  private
  def permitted_params
    params.require(:license).permit(:preset_name, :holder_name, :holder_email, :holder_address, :custom_license_name, :custom_license_url)
  end

  def decide_template
    params[:render]
  end
end
