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

RSpec.describe AccountController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context "GET show" do
      it "has a 200 status code" do
        get :show, locale: :en, id: @user
        expect(response.status).to eql(200)
      end
    end

    context "PUT update" do
      before :each do
        put :update, locale: :en, id: @user, user: {first_name: 'john', last_name: 'doe', language: 'de'}
        @user.reload
      end
      
      it { expect(@user.first_name).to eql('john') }
      it { expect(@user.last_name).to eql('doe') }
      it { expect(@user.language).to eql('de') }
      it { expect(response.status).to eql(200) }
    end
  end

  describe "Guest" do
    before :each do
      @user = User.where(email: 'nothing@nothing.not').first
    end

    context "GET new" do
      it "wrong invitation code" do
        # get :new, locale: :en, invitation: 235468765
        # expect(response.status).to eql(403)
      end
    end

    context "POST create" do
      it "should create new user" do
        attrs = { username: "test", password: "test", email: "test@example.com" }
        xhr :post, :create, locale: :en, user: attrs
        expect(response.status).to eql(200)
      end
    end

    context "PUT update" do
      before :each do
        put :update, format: :json, locale: :en, id: @user, user: {first_name: 'john', last_name: 'doe', language: 'de'}
        @user.reload
      end
      
      it { expect(response.status).to eql(401) }
    end
  end
end
