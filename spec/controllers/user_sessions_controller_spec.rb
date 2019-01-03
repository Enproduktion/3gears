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

RSpec.describe UserSessionsController, :type => :controller do
  describe "Guest" do
    before :each do
      activate_authlogic
    end

    context "POST Create" do
      it "should logged in with user privilege ( javascript )" do
        post :create, format: :js, locale: :en, user_session: { login: User.default_user.username, password: "default" }
        expect(response.status).to eql(200)
      end

      it "should logged in with user privilege ( html )" do
        post :create, format: :html, locale: :en, user_session: { login: User.default_user.username, password: "default" }
        expect(response.status).to eql(302)
      end

      it "should show error message because username not found" do
        post :create, locale: :en, user_session: { login: "3doxnotfound", password: "default" }
        expect(response.status).to eql(302)
      end

      it "should show error message because wrong password" do
        post :create, locale: :en, user_session: { login: User.default_user, password: "123456789" }
        expect(response.status).to eql(302)
      end
    end
  end

  describe "User" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context "POST Create" do
      it "should raise error because user already logged in" do
        post :create, locale: :en, user_session: { login: User.default_user.username, password: "default" }
        expect(response.status).to eql(302)
      end
    end

    context "DELETE Destroy" do
      before :each do
        delete :destroy, locale: :en
      end

      it { expect(response.status).to eql(302) }
      it { expect(UserSession.find(@user)).to be_nil }
    end
  end
end
