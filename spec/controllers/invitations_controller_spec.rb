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

RSpec.describe InvitationsController, :type => :controller do
  describe "Admin logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'admin@3gears.org').first
      UserSession.create(@user)
    end

    context "GET new" do
      before :each do
        get :new, locale: :en
      end

      it { expect(response.status).to eql(200) }
    end

    context "POST create" do
      it "should create invitation" do
        post :create, locale: :en, invitation: {email: "invite_person@3gears.org"}
        expect(response.status).to eql(302)
      end
    end

  end
end
