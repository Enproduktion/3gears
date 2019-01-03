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

RSpec.describe ReportViolationsController, :type => :controller do
  describe "User Logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context "POST create" do
      before :each do
        @movie = MovieOrIdea.where(is_idea: false).first
        @footage = Footage.first
      end

      it 'should create report violation from movie or idea class' do
        post :create, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie, report_violation: { report_type: 1, message: 'Reported' }
        expect(response.status).to eql(201)
      end

      it 'should be unprocessable movie or idea because nil report type' do
        post :create, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie, report_violation: { report_type: nil }
        expect(response.status).to eql(422)
      end

      it 'should be unprocessable movie or idea because not in list report type' do
        post :create, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie, report_violation: { report_type: 322 }
        expect(response.status).to eql(422)
      end

      it 'should create report violation from footage class' do
        post :create, locale: :en, parent_class: 'Footage', footage_id: @footage, report_violation: { report_type: 1, message: 'Reported' }
        expect(response.status).to eql(201)
      end

      it 'should be unprocessable footage because nil report type' do
        post :create, locale: :en, parent_class: 'Footage', footage_id: @footage, report_violation: { report_type: nil }
        expect(response.status).to eql(422)
      end

      it 'should be unprocessable footage because not in list report type' do
        post :create, locale: :en, parent_class: 'Footage', footage_id: @footage, report_violation: { report_type: 322 }
        expect(response.status).to eql(422)
      end
    end
  end
end
