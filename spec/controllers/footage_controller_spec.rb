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

RSpec.describe FootageController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
      @footage = @user.footage.first
    end

    context "GET new" do
      it "can create footage" do
        get :new, locale: :en
        expect(response.status).to eql(302)
      end
    end

    context "GET show" do
      it 'should show selected footage' do
        get :show, locale: :en, id: @footage
        expect(response.status).to eql(200)
      end
    end

    context "PUT update" do
      before :each do
        attrs = {title: 'title one', abstract: 'abstract one'}
        put :update, locale: :en, id: @footage, footage: attrs
        @footage.reload
      end

      it { expect(@footage.title).to eql('title one') }
      it { expect(@footage.abstract).to eql('abstract one') }
    end

    context "DELETE destroy" do
      it "should delete footage" do
        delete :destroy, locale: :en, id: @footage
        if Frontend::is_empty_style?
          expect(response.status).to eql(200)
        end
      end
    end
  end

  describe "Guest" do
    context "GET new" do
      it 'should not has access to create footage' do
        get :new, locale: :en
        expect(response.status).to eql(302)
      end
    end
  end
end
