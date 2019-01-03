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

class AccountMailer < ActionMailer::Base
  default from: "noreply@audiovisuellesarchiv.org"

  def confirmation(user)
    @user = user
    mail(to: user.email, subject: t("user.confirmation_mail_subject"))
  end

  def email_verification(user)
    @user = user
    mail(to: user.email, subject: t("user.email_verification_subject"))
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: t("user.password_reset_subject"))
  end

  def admin_delete(user, message)
    @user = user
    @message = message
    mail(to: user.email, subject: t("user.admin_delete_subject"))
  end

  def invitation(email, locale, invitation)
    I18n.locale = locale
    @email = email
    @invitation_url = new_account_url(invitation: invitation.token, locale: locale)
    mail(to: email, subject: t("user.invitation_mail_subject"))
  end

  def recover_password(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Forgot Password Recovery')
  end
end
