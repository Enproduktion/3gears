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

RSpec.describe DocumentsController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
      @ability = Ability.new(@user)
    end

    context "POST create" do
      before :each do
        @movie_or_idea = MovieOrIdea.first
      end

      it "document" do
        attrs  = { document: Rack::Test::UploadedFile.new('spec/fixtures/file.pdf', 'application/pdf') }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(201)
      end

      it "document and add name to file" do
        attrs  = { document: Rack::Test::UploadedFile.new('spec/fixtures/file.pdf', 'application/pdf'), document_file_name: "custom.pdf" }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(201)
      end

      it "image document" do
        attrs  = { document: Rack::Test::UploadedFile.new('spec/fixtures/article.jpg', 'images/jpeg') }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(201)
      end

      it "empty document" do
        attrs  = { document: "" }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(422)
      end

      it "nil document" do
        attrs  = { document: nil }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(422)
      end
    end

    context "PUT update" do
      before :each do
        @movie_or_idea = MovieOrIdea.first
        @document = Document.first
      end

      it "should update document name" do
        put :update, format: :json, locale: :en, id: @document, document: {document_file_name: "file_new.pdf"}
        @document.reload
        expect(response.status).to eql(200)
        expect(@document.document_file_name).to eql('file_new.pdf')
      end

      it "shouldn't update document" do
        put :update, format: :json, locale: :en, id: @document, document: {document_file_name: ""}
        expect(response.status).to eql(422)
      end
    end

    context "GET download" do

      before :each do
        @document = Document.first
      end

      it "should download document" do
        get :download, locale: :en, parent_class: 'MovieOrIdea',  id: @document, movie_or_idea_id: @document.movie_or_idea
        expect(response.header['Content-Type']).to eql("application/pdf")
      end
    end

    context "DELETE destroy" do
      it "should delete document" do
        @document = Document.first
        delete :destroy, locale: :en, parent_class: 'MovieOrIdea', id: @document, movie_or_idea_id: @document.movie_or_idea
        expect(response.status).to eql(200) 
      end
    end
  end

  describe "Guest" do
    before :each do
      @movie_or_idea = MovieOrIdea.first
    end

    context "POST create" do
      it "create document" do
        attrs  = { document: Rack::Test::UploadedFile.new('spec/fixtures/file.pdf', 'application/pdf') }
        post :create, format: :json, locale: :en, parent_class: 'MovieOrIdea', movie_or_idea_id: @movie_or_idea, document: attrs
        expect(response.status).to eql(401)
      end
    end
  end
end
