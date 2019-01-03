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

class Organisation < ActiveRecord::Base

  default_value_for :abstract, ""

  include Taggable

  #
  # Relations
  #

  belongs_to :user

  has_many :movies_and_ideas, dependent: :destroy
  has_many :footage, dependent: :destroy

  has_many :user_organisations, dependent: :destroy
  has_many :users, through: :user_organisations

  has_many :occupations, as: :occupationable, dependent: :destroy

  #
  # Validations
  #

  validates :name, :user, presence: true
  validates_uniqueness_of :name

  #
  # Attachment
  #
  include Avatarable
  include Coverable

  include RealtimeIndice
  include QuickSearch

  #
  # Callback
  #

  before_create :set_token
  after_create :send_confirmation, :add_to_organisation_member

  #
  # Class Methods
  #
  class << self
    def quick_search(query)
      Organisation.default_quick_search(query, {url: 'organisation_path', field: 'name', title: 'Organisation'})
    end
  end

  def has_member?(user)
    users.include?(user)
  end

  private
  def set_token
    self.token = SecureRandom.hex
  end

  def send_confirmation
    NotificationMailer.created_organisation(self.user, self).deliver_now
  end

  def add_to_organisation_member
    UserOrganisation.create(user: self.user, organisation: self)
  end
end
