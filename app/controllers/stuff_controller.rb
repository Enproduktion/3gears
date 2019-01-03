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

class StuffController < ApplicationController
  include HasPolymorphicParent
  before_filter { @usedfor = find_polymorphic_parent }
  authorize_resource :usedfor
  load_and_authorize_resource :stuff, through: :usedfor

  # create stuff for movie or idea
  # 
  def create

    if params[:who].blank?
      render_errors(@stuff, :unprocessable_entity)
      return
    end

    @stuff.supplier = User.find_by_username(params[:who])

    define_user_stuff

    if @stuff.save
      @stuff.send_notification(params[:message]) if @stuff.supplier != current_user
      render @stuff, locals: { usedfor: @usedfor, editable: true }
    else
      render_errors(@stuff, :unprocessable_entity)
    end
  end

  # delete stuff
  # 
  def destroy
    @stuff.destroy
    head :ok
  end

  private
  def create_params
    params.require(:stuff).permit(:name)
  end

  def define_user_stuff
    if not @stuff.supplier and not params[:who].blank?
      if User.where(email: params[:who]).exists?
        @stuff.supplier_id = User.where(email: params[:who]).first.id
      elsif User.where(username: params[:who]).exists?
        @stuff.supplier_id = User.where(username: params[:who]).first.id
      else
        @stuff.invited_email = params[:who]
      end
    end
  end
end
