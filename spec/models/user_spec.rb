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

RSpec.describe User, :type => :model do
  context "Attributes" do
    it { should respond_to :email }
    it { should respond_to :username }
    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :abstract }
    it { should respond_to :field_of_work }
    it { should respond_to :role }
    it { should respond_to :country }
    it { should respond_to :language }
  end

  context "Relations" do
    it { should have_many(:subscriptions) }
    it { should have_many(:notifications) }
    it { should have_many(:tags) }
    it { should have_many(:footage) }
    it { should have_many(:movies_and_ideas) }
  end

  context "Attachments" do
    it { should respond_to :avatar_content_type }
    it { should respond_to :avatar_file_name }
    it { should respond_to :avatar_file_size }
    it { should respond_to :avatar_updated_at }
    it { should respond_to :picture_content_type }
    it { should respond_to :picture_file_name }
    it { should respond_to :picture_file_size }
    it { should respond_to :picture_updated_at }
  end

  context "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:role) }
  end

  context "Instance Methods" do
    before :each do
      @user = User.default_user
      @editor = User.where(role: "editor").first
    end

    it "should return full name" do
      @user.first_name = "User"
      @user.last_name  = "3dox"
      @user.save!
      expect(@user.full_name).to eql("User 3dox")
    end

    it "should return username if full_name is empty" do
      @user.first_name = ""
      @user.last_name = ""
      @user.save!
      expect(@user.full_name).to eql(@user.username)
    end

    it "should return username" do
      expect(@user.to_param).to eql(@user.username)
    end

    it "should return false editor status" do
      expect(@user.editor?).to be false
    end

    it "should return true editor status" do
      expect(@editor.editor?).to be true
    end

    it "should check admin status" do
      expect(@user.admin?).to be false
    end

    it "should request new email" do
      @user.request_new_email("newemail@3dox.org")
      expect(@user.new_email).to eql("newemail@3dox.org")
    end
  end
end
