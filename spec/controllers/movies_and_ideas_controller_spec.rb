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

RSpec.describe MoviesAndIdeasController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)

      @movie = MovieOrIdea.where(is_idea: false).first
      @idea = MovieOrIdea.where(is_idea: true).first
    end

    context "GET new" do
      it "should create idea and redirect" do
        get :new, locale: :en, as_idea: true
        expect(response.status).to eql(302)
      end

      it "should create movie and redirect" do
        get :new, locale: :en, as_idea: false
        expect(response.status).to eql(302)
      end
    end

    context "GET show" do
      it "show movie and has 200 response code" do
        get :show, locale: :en, id: @movie, as_idea: false
        expect(response.status).to eql(200)
      end

      it "show idea and has 200 response code" do
        get :show, locale: :en, id: @idea, as_idea: true
        expect(response.status).to eql(200)
      end

      it "should redirect if @idea and as_idea false" do
        get :show, locale: :en, id: @idea, as_idea: false
        expect(response.status).to eql(302)
      end
    end

    context "PUT update" do
      it "should update attributes movie or idea" do
      end
    end

    context "DELETE destroy" do
      it "should delete movie or idea" do
        delete :destroy, locale: :en, id: @movie
        expect(response.status).to eql(302)
      end
    end

    # context "POST make_movie" do
    #   it "should change idea to movie" do
    #     post :make_movie, locale: :en, id: @idea
    #     expect(@idea.is_idea).to be false
    #   end
    # end
  end
end
