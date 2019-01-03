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

class Subscription < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :object, polymorphic: true

  # Validations
  validates :user, :object, presence: true
  validates_uniqueness_of :event, scope: [:user_id, :object_id, :object_type]

  # 
  # Class methods
  # 
  class << self
    def from_user(user)
      where(user_id: user.id)
    end

    def with_event(event)
      where(event: event)
    end

    def with_object(object)
      where(object_id: object.id, object_type: object.class.name)
    end

    def subscribed_to?(user, object, event)
      from_user(user).with_object(object).with_event(event).exists?
    end
  end
end
