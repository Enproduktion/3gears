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

class SpecificationsController < ApplicationController
  include HasPolymorphicParent
  before_filter { @specable = find_polymorphic_parent }
  authorize_resource :specable
  load_and_authorize_resource :specification, through: :specable

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Create spec
  # @spec is created from load_and_authorize_resource :spec, through: :specable
  # this will load 'create_params' private method
  # for passing protected parameters
  # 
  def create
    create_project_items(@specification, {specable: @specable, editable: true})
  end

  # update spec
  def update
    update_project_items(@specification, {specable: @specable, editable: true}, update_params)
  end

  # delete spec
  # from movie, idea or footage
  def destroy
    @specification.destroy
    head :ok
  end

  private
  def create_params
    params.require(:specification).permit(:spec, :value)
  end
  alias_method :update_params, :create_params
end
