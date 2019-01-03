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

class NotificationMailer < ActionMailer::Base
  default from: "noreply@audiovisuellesarchiv.org"

  def added_as_crew_member(user, message)
    @user = user
    @confirmation_url = ""
    @message = message
    mail(to: user.email, subject: t("notification.added_as_crew_member_subject"))
  end

  def invite_crew_member(email, message)
    @confirmation_url = ""
    @message = message
    mail(to: email, subject: t("notification.invite_crew_member_subject"))
  end

  def added_as_supplier(user, message)
    @user = user
    @confirmation_url = ""
    @message = message
    mail(to: user.email, subject: t("notification.added_as_supplier_subject"))
  end

  def invite_supplier(email, message)
    @confirmation_url = ""
    @message = message
    mail(to: email, subject: t("notification.invite_supplier_subject"))
  end

  def report_crew_open(user, message)
    @message = message
    mail(to: user.email, subject: t("notification.report_crew_open_subject"))
  end

  def request_to_supply_equipment(owner, supplier, equipment)
    @owner = owner
    @supplier = supplier
    @equipment = equipment
    mail(to: owner.email, subject: "#{@supplier.username} want to supply #{@equipment.tool}")
  end

  def created_organisation(user, organisation)
    @user = user
    @organisation = organisation
    mail(to: @user.email, subject: "#{@organisation.name} confirmation")
  end
end
