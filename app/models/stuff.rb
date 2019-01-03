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

class Stuff < ActiveRecord::Base
  # Relations
  belongs_to :supplier, class_name: "User"
  belongs_to :usedfor, polymorphic: true

  has_many :notifications, as: :object, dependent: :destroy

  validates :usedfor, :name, presence: true

  validates :invited_email, absence: true, if: :supplier_id?

  validates_length_of :invited_email, validates_length_of_email_field_options.merge(allow_nil: true)
  validates_format_of :invited_email, validates_format_of_email_field_options.merge(allow_nil: true)

  # 
  # Instance methods
  #

  # create notification and send an email
  def send_notification(message)
    if supplier
      Notification.create({
        user: supplier,
        notification_type: "added_as_supplier",
        object: usedfor,
        message: message,
      })
      NotificationMailer.added_as_supplier(supplier, message).deliver_now
    elsif invited_email
      NotificationMailer.invite_supplier(invited_email, message).deliver_now
    end
  end
end
