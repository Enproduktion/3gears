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

RSpec.describe OrganisationsController, :type => :controller do

  describe "User Logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
      @organisation = Organisation.where(name: '3gears Org').first
    end

    context "GET index" do
      it "should be success" do
        get :index, locale: :en
        expect(response.status).to eql(200)
      end
    end

    context "POST create" do
      it "should create organisation" do
        post :create, locale: :en, organisation: { password: 'default', name: '3dox test' }
        organisation = Organisation.where(name: '3dox test').empty?
        expect(organisation).to be false
      end

      it "should not create organisation" do
        post :create, locale: :en, organisation: { password: 'asdfasdf', name: '3gears test' }
        organisation = Organisation.where(name: '3gears test').empty?
        expect(organisation).to be false
      end
    end

    context "POST confirm" do
      it "should confirm organisation" do
        
      end
    end

    context "POST use" do
      it "should use created organisation" do
        post :use, locale: :en, id: @organisation
        expect(session[:organisation]).to eql(@organisation.token)
      end
    end

    context "GET clear" do
      it "should clear organisation" do
        get :clear, locale: :en
        expect(session[:organisation]).to be nil
      end
    end
  end

  describe "Guest" do
    context "GET index" do
      it "should be success" do
        get :index, locale: :en
        expect(response.status).to eql(200)
      end
    end
  end
end
