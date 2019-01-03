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

require "rails_helper"

RSpec.describe AccountMailer, :type => :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe "Confirmation" do
    before(:all) do
      @user = User.default_user
      I18n.locale = 'de'
      @email = AccountMailer.confirmation(@user).deliver_now
    end

    it "should be set to be delivered to user email" do
      expect(@email).to deliver_to(@user.email)
    end

    it "should deliver from correct account email" do
      expect(@email).to deliver_from("noreply@audiovisuellesarchiv.org")
    end

    it "should contain user's username on email body" do
      expect(@email).to have_body_text(@user.username)
    end

    it "should have email confirmation subject" do
      expect(@email).to have_subject("Account bestätigen")
    end
  end

  describe "Email Verification" do
    before(:all) do
      @user = User.default_user
      @user.new_email = "newemail@email.com"
      @user.new_email_token = Authlogic::Random.friendly_token
      @user.save
      I18n.locale = 'de'
      @email = AccountMailer.email_verification(@user).deliver_now
    end

    it "should be set to be delivered to user old email" do
      expect(@email).to deliver_to(@user.email)
    end

    it "should deliver from correct email" do
      expect(@email).to deliver_from("noreply@audiovisuellesarchiv.org")
    end

    it "should contain user's username on email body" do
      expect(@email).to have_body_text(@user.username)
    end

    it "should contain email verification message" do
      expect(@email).to have_body_text("Folgenden Link anklicken um die neue Adresse zu bestätigen")
    end

    it "should have email verification subject" do
      expect(@email).to have_subject("E-Mailadresse verifizieren")
    end
  end

  describe "Password Reset" do
    before(:all) do
      @user = User.default_user
      I18n.locale = 'de'
      @email = AccountMailer.password_reset(@user).deliver_now
    end

    it "should be set to be delivered to user old email" do
      expect(@email).to deliver_to(@user.email)
    end

    it "should deliver from correct account email" do
      expect(@email).to deliver_from("noreply@audiovisuellesarchiv.org")
    end

    it "should contain user's username on email body" do
      expect(@email).to have_body_text(@user.username)
    end

    it "should contain email verification message" do
      expect(@email).to have_body_text("Folgenden Link anklicken um die neue Adresse zu bestätigen")
    end

    it "should have email verification subject" do
      expect(@email).to have_subject("Passwort zurücksetzen")
    end
  end
end
