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

RSpec.describe MediumTimeTagsController, type: :controller do
  describe "User logged in" do
    before :each do
      activate_authlogic
      @user = User.where(email: 'nothing@nothing.not').first
      UserSession.create(@user)
    end

    context 'GET index' do

      it 'should have index' do
        @medium = Medium.first
        get  :index, locale: :en, medium_id: @medium
        expect(response.status).to eql(200)
      end
    end

    context 'POST create' do
      before :each do
        @medium = Medium.first
        @tag = Tag.first
      end

      it 'should create medium_time_tag' do
        old_count = MediumTimeTag.count
        attrs = {start_time: 0, end_time: 1, tag_name: @tag.name}
        post :create, locale: :en, medium_id: @medium, medium_time_tag: attrs
        expect(response.status).to eql(201)
        expect(MediumTimeTag.count).to eq(old_count+1)
      end

      # it 'should create medium_time_tag and tag for new tag' do
      #   old_count = MediumTimeTag.count
      #   old_tag_count = Tag.count
      #   attrs = {start_time: 0, end_time: 1, tag_name: "definitelynewtag"}
      #   post :create, locale: :en, medium_id: @medium, medium_time_tag: attrs
      #   expect(response.status).to eql(201)
      #   expect(MediumTimeTag.count).to eq(old_count+1)
      #   expect(Tag.count).to eq(old_tag_count+1)
      # end

      it 'should not create medium_time_tag with empty tag' do
        attrs = {start_time: 0, end_time: 1}
        post :create, locale: :en, medium_id: @medium, medium_time_tag: attrs
        expect(response.status).to eql(422)
      end
  end

    describe 'PUT update' do
      before :each do
        @medium = Medium.first
        @medium.tags << Tag.first
        @medium_time_tag = @medium.medium_time_tags.first
      end

      context 'Success' do
        it "update" do
          attrs = {start_time: 3, end_time: 4}
          put :update, locale: :en, medium_id: @medium, id: @medium_time_tag, medium_time_tag: attrs
          @medium_time_tag.reload

          expect(@medium_time_tag.start_time).to eql(3)
          expect(@medium_time_tag.end_time).to eql(4)
          expect(response.status).to eql(200)
        end

        it "update nil start/end time" do
          attrs = {start_time: nil, end_time: nil}
          put :update, locale: :en, medium_id: @medium, id: @medium_time_tag, medium_time_tag: attrs
          @medium_time_tag.reload

          expect(@medium_time_tag.start_time).to eql(nil)
          expect(@medium_time_tag.end_time).to eql(nil)
          expect(response.status).to eql(200)
        end
        #
        # it "creates tag for new tagname", focus: true  do
        #   old_tag_count = Tag.count
        #   attrs = {start_time: 0, end_time: 1, text: "", tag_name: "thisshouldbenoexistingtagname"}
        #   put :update, locale: :en, medium_id: @medium, id: @medium_time_tag, medium_time_tag: attrs
        #   expect(Tag.count).to eq(old_tag_count+1)
        # end
      end
    end

    context "DELETE destroy" do
      before :each do
        @medium = Medium.first
        @medium.tags << Tag.first
        @medium_time_tag = @medium.medium_time_tags.first
        delete :destroy, locale: :en, medium_id: @medium, id: @medium_time_tag
      end

      it { expect(response.status).to eql(200) }
    end
  end

  describe 'Guest' do
    context 'Get index' do
      it 'should have access' do
        @medium = Medium.first
        get :index, locale: :en, medium_id: @medium
        expect(response.status).to eql(200)
      end
    end

    context 'POST create' do
      it 'should not have access' do
        attrs = {start_time: 3, end_time: 4}
        @medium = Medium.first
        post :create, locale: :en, medium_id: @medium, medium_time_tag: attrs
        expect(response.status).to eql(302)
      end
    end

    context 'PUT update' do
      it 'should not has access' do
        @medium = Medium.first
        @medium.tags << Tag.first
        @medium_time_tag = @medium.medium_time_tags.first
        attrs = {start_time: 3, end_time: 4}
        put :update, locale: :en, medium_id: @medium, id: @medium_time_tag, medium_time_tag: attrs
        expect(response.status).to eql(302)
      end
    end

    context 'DELETE destroy' do
      before :each do
        @medium = Medium.first
        @medium.tags << Tag.first
        @medium_time_tag = @medium.medium_time_tags.first
        delete :destroy, locale: :en, medium_id: @medium, id: @medium_time_tag
      end

      it { expect(response.status).to eql(302) }
    end
  end
end
