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

RSpec.describe AccountPasswordController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context "GET edit" do
      it 'should has 200 response conde' do
        get :edit, locale: :en
        expect(response.status).to eql(200)
      end
    end

    context "PUT update" do
      context 'valid' do
        before :each do
          put :update, locale: :en, user: {password: 'default', new_password: 'serigala', password_confirmation: 'serigala'}
          @user.reload
        end

        it 'should valid new password' do
          expect(@user.valid_password?('serigala')).to eql(true)
        end

        it 'should update password' do
          expect(response.status).to eql(200)
        end
      end

      context 'invalid' do
        it 'should refuse without password confirmation' do
          put :update, locale: :en, user: {password: 'default', new_password: 'serigala'}
          @user.reload
          expect(@user.valid_password?('serigala')).to eql(false)
        end
      end
    end
  end
end
