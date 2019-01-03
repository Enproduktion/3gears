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

RSpec.describe SpecificationsController, :type => :controller do
  describe "User Logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context "POST create" do
      before :each do
        @movie_or_idea = MovieOrIdea.first
      end

      it "should create spec" do
        attrs = { spec: "Camera", value: "18MP" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(201)
      end

      it "same spec" do
        attrs = { spec: "Monitor", value: "2" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "empty spec" do
        attrs = { spec: "", value: "18MP" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "nil spec" do
        attrs = { spec: nil, value: "18MP" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "empty value" do
        attrs = { spec: "Camera", value: "" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "nil value" do
        attrs = { spec: "Camera", value: nil }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "empty spec & value" do
        attrs = { spec: "", value: "" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end

      it "nil spec & value" do
        attrs = { spec: nil, value: nil }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(422)
      end
    end

    describe "PUT update" do
      before :each do
        @movie_or_idea = MovieOrIdea.first
        @spec = @movie_or_idea.specs.first
      end

      context "success" do
        before :each do
          attrs = { spec: "Cameraw", value: "10MP" }
          put :update, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec, specification: attrs
          @spec.reload
        end
        
        it { expect(response.status).to eql(200) }
        it { expect(@spec.spec).to eql("Cameraw") }
        it { expect(@spec.value).to eql("10MP") }
      end

      context "failure" do
        it "empty spec and value" do
          attrs = { spec: "", value: "" }
          put :update, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec, specification: attrs
          expect(response.status).to eql(422)
        end

        it "nil spec and value" do
          attrs = { spec: nil, value: nil }
          put :update, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec, specification: attrs
          expect(response.status).to eql(422)
        end
      end
    end

    context "DELETE destroy" do
      it "delete spec" do
        @movie_or_idea = MovieOrIdea.first
        @spec = @movie_or_idea.specs.first 
        delete :destroy, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec
        expect(response.status).to eql(200)
      end
    end
  end

  describe "Guest" do
    before :each do
      @movie_or_idea = MovieOrIdea.first
    end

    context "POST create" do
      it "unauthorized" do
        attrs = { spec: "Camera", value: "18MP" }
        post :create, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, specification: attrs
        expect(response.status).to eql(302)
      end
    end

    context "PUT update" do
      it "unauthorized" do
        @movie_or_idea = MovieOrIdea.first
        @spec = @movie_or_idea.specs.first
        attrs = { spec: "Cameraw", value: "10MP" }
        put :update, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec, specification: attrs
        expect(response.status).to eql(302)
      end
    end

    context "DELETE destroy" do
      it "unauthorized" do
        @movie_or_idea = MovieOrIdea.first
        @spec = @movie_or_idea.specs.first
        delete :destroy, locale: :en, parent_class: "MovieOrIdea", movie_or_idea_id: @movie_or_idea, id: @spec
        expect(response.status).to eql(302)
      end
    end
  end
end
