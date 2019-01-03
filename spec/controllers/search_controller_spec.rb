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

RSpec.describe SearchController, :type => :controller do
  describe "User logged in" do
    before :each do 
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end
    
    context "GET show" do
      it "should success and return search results"do
        expect{ get :show, locale: :en }.to raise_error(ArgumentError)
      end
    end
  end

  describe "Guest" do
    context "GET show" do
      it "should not has access" do
        expect{ get :show, locale: :en }.to raise_error(ArgumentError)
      end
    end
  end
end
