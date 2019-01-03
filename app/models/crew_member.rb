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

class CrewMember < ActiveRecord::Base
  default_value_for :occupation, ""

  # Relations
  belongs_to :user
  belongs_to :work, polymorphic: true

  has_many :notifications, as: :object, dependent: :destroy
  has_many :occupations,   as: :occupationable, dependent: :destroy

  accepts_nested_attributes_for :occupations, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :work, presence: true
  # validates :occupation, exclusion: { in: [nil], message: "cannot be nil" }
  validates :invited_email, inclusion: { in: [nil] }, if: :user_id?

  validates_length_of :invited_email, validates_length_of_email_field_options.merge(allow_nil: true)
  validates_format_of :invited_email, validates_format_of_email_field_options.merge(allow_nil: true)

  # validates_uniqueness_of :occupation, scope: [:user_id, :work_id, :work_type], if: :user_id?
  # validates_uniqueness_of :occupation, scope: [:invited_email, :work_id, :work_type], if: :invited_email?

  scope :only_footage, -> { where("crew_members.work_type = 'Footage'") }
  scope :only_movies_or_ideas, -> { where("crew_members.work_type = 'MovieOrIdea'") }
  scope :ready_for_export, -> { where.not(user: nil) }

  # 
  # Instance methods 
  # 

  def send_notification(message)
    if user
      Notification.create({
        user: user,
        notification_type: "added_as_crew_member",
        object: work,
        message: message,
      })
      NotificationMailer.added_as_crew_member(user, message).deliver_now
    elsif not invited_email.blank?
      NotificationMailer.invite_crew_member(invited_email, message).deliver_now
    else
      Subscription.with_object(work).with_event("crew_open").each do |subscription|
        Notification.create({
          user: subscription.user,
          notification_type: "crew_open",
          object: work,
          message: message,
        })
        NotificationMailer.report_crew_open(subscription.user, message).deliver_now
      end
    end
  end

  def update_occupations(occupation_names)
    occupation_names.reject! &:blank?
    occupation_names.uniq!

    self.occupations = occupation_names.map do |name|
      Occupation.new(occupation: name.downcase)
    end
  end

end
