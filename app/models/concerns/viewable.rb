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

module Viewable

  extend ActiveSupport::Concern

  included do

    # Set default value viewable to private
    default_value_for :viewable_by_all, 0

    scope :only_viewable_by_all, -> { where(viewable_by_all: 2) }
    scope :public_items, -> { where(viewable_by_all: 2) }
    scope :team_items, -> { where(viewable_by_all: 1) }

    scope :recently_published_first, -> { order("published_at DESC") }

    before_validation do
      self.published_at = Time.now if viewable_by_all_changed? && !published_at
      true
    end
  end

  module ClassMethods
    def viewable_by(user, organisation = nil)
      if organisation.valid?
        where("(organisation_id = ?) OR viewable_by_all = ?", organisation.id, 2)
      else
        where("(user_id = ?) OR viewable_by_all = ? OR id IN (?)", 
                user.id, 
                2,
                CrewMember.where("user_id = ? AND work_id NOT IN (?) AND work_type = ?", 
                  user.id, 
                  self.select(:id).where(viewable_by_all: 0) , self).map(&:work_id))
      end
    end

    def viewable
      {
          "Private" => 0,
          "Team"    => 1,
          "Public"  => 2
      }
    end

    def viewable_priv_or_pub
      {
          "Private" => 0,
          "Public"  => 2
      }
    end
  end

  def published?
    published_at != nil && viewable_by_all == self.class.viewable['Public']
  end

  # Return true or false
  # user can see selected footage?
  # this method used on ability.rb
  # 
  def viewable_by?(user, organisation = nil)
    case viewable_by_all
    when 0
      self.user == user || self.organisation == organisation
    when 1
      self.owner_and_teams.include?(user.id)
    when 2
      true
    end
  end

  def teams
    crew_members.map(&:user_id).uniq
  end

  def owner_and_teams
    teams << self.user.id
  end

  def viewable_text
    self.viewable.key(self.viewable_by_all)
  end

end
