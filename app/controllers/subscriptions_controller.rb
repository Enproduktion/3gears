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

class SubscriptionsController < ApplicationController
  include HasPolymorphicParent

  before_filter { @object = find_polymorphic_parent }
  authorize_resource :object

  def create
    @object.subscriptions.create({
      user: current_user,
      event: session[:event]
    })

    render partial: "subscriptions/#{session[:event]}", locals: { object: @object }
  end

  def destroy
    @object.subscriptions.from_user(current_user).with_event(session[:event]).destroy_all

    render partial: "subscriptions/#{session[:event]}", locals: { object: @object }
  end
end
