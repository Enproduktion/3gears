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

RSpec.describe ShariffController, :type => :controller do
  describe "User Logged in" do
    before :each do
      activate_authlogic
      @user = User.default_user
      UserSession.create(@user)
    end

    context "GET shariff default domain" do
      before(:each) do
        get :shariff
      end

      it { expect(response.content_type).to eql("application/json") }
      it { expect(response.status).to eql(200) }
    end

    context "GET shariff custom domain" do
      before :each do
        get :shariff, param: { url: "http://www.google.com" }
      end

      it { expect(response.content_type).to eql("application/json") }
      it { expect(response.status).to eql(200) }
    end
  end

  describe "Guest" do
  end
end
