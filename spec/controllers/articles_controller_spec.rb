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

RSpec.describe ArticlesController, :type => :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(user)
    end

    context "GET index" do
      it "has a 200 status code" do
        get :index, locale: :en
        expect(response.status).to eql(200)
      end
    end

    context "GET new" do
      it 'should not have access' do
        get :new, locale: :en
        expect(response.status).to eql(302)
      end
    end
  end

  describe "Editor logged in" do
    before :each do
      activate_authlogic
      user = User.where(email: 'bra@bra.bra').first
      UserSession.create(user)
      @article = Article.first
    end

    context "GET index" do
      it "has a 200 status code" do
        get :index, locale: :en
        expect(response.status).to eql(200)
      end
    end

    context "GET new" do
      it "should has access to create article" do
        get :new, locale: :en
        expect(response.status).to eql(302)
      end
    end

    context "PUT update" do
      before :each do
        attrs = { published: true }
        put :update, locale: :en, id: @article, article: attrs
        @article.reload
      end
      
      it 'should change article to published' do
        expect(@article.published?).to eq true
      end

      it { expect(response.status).to eql(302) }
    end

    context "DELETE destroy" do
      it 'should delete article' do
        delete :destroy, locale: :en, id: @article
        expect(response.status).to eql(302)
      end
    end
  end

  describe "Guest" do
    it "has a 200 status code" do
      expect(response.status).to eql(200)
    end

    it 'should not has access' do
      get :new, locale: :en
      expect(response.status).to eql(302)
    end
  end
end
