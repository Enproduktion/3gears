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
require 'rack/test'

RSpec.describe StillsController, :type => :controller do
  describe "User Logged in" do
    before :each do
      activate_authlogic
      @user = User.default_user
      UserSession.create(@user)
    end

    context "POST create" do
      before :each do
        @not_owned_movie = MovieOrIdea.where(is_idea: false).where.not(user_id: @user.id).first
        @owned_movie = MovieOrIdea.where(is_idea: false).where(user_id: @user.id).first
      end

      it 'should create still from movie or idea' do
        post :create, format: :json, locale: :en, movie_or_idea_id: @owned_movie, still: { content: Rack::Test::UploadedFile.new('spec/fixtures/images.jpg', 'image/jpeg') }
        expect(response.status).to eql(201)
      end

      it 'forbidden' do
        post :create, format: :json, locale: :en, movie_or_idea_id: @not_owned_movie, still: { content: Rack::Test::UploadedFile.new('spec/fixtures/images.jpg', 'image/jpg') }
        expect(response.status).to eql(403)
      end
    end
  end

  describe "Guest" do
    context "Post create" do
      it 'should not have access' do
        movie = MovieOrIdea.where(is_idea: false).first
        attrs = { content: Rack::Test::UploadedFile.new('spec/fixtures/images.jpg', 'image/jpg') }
        post :create, format: :json, locale: :en, movie_or_idea_id: movie, still: attrs
        expect(response.status).to eql(401)
      end
    end
  end
end
