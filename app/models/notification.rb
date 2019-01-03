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

class Notification < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :object, polymorphic: true

  # Validations
  validates :user, :object, :notification_type, presence: true
  validates :unread, exclusion: { in: [nil], message: "cannot be nil" }

  # Scopes
  scope :newest_first, -> { order(:created_at) }
  scope :only_unread, -> { where(unread: true) }

  # def self.mark_as_read
  #   # update_all ignores OFFSET; circumvented by weird join syntax
  #   joins(" ").update_all(unread: false)
  # end

  # 
  # Class methods
  # 
  class << self
    def from_user(user)
      where(user_id: user.id)
    end
  end
end
