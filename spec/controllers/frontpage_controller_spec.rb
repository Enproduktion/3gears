# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rails_helper'

RSpec.describe FrontpageController, :type => :controller do
  describe "GET index" do
    context "User Logged in" do
      before :each do
        activate_authlogic
        user = User.where(email: 'nothing@nothing.not').first
        UserSession.create(user)
      end

      it "has a 200 status code" do
        get :index, locale: :en
        expect(response.status).to eql(200)
      end
    end

    context "Guest" do
      it "has a 401 status code" do
        get :index, locale: :en
        if Frontend::APP_STYLE.empty?
          expect(response.status).to eql(401)
        else
          expect(response.status).to eql(200)
        end
      end
    end
  end
end
