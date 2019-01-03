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

module OrganisationValidation

  extend ActiveSupport::Concern

  included do

    with_options unless: :is_organisation? do |user|
      user.validates :user, presence: true
      user.validates :organisation, presence: false, allow_nil: true
    end

    with_options if: :is_organisation? do |organisation|
      organisation.validates :organisation, presence: true
      organisation.validates :user, presence: false, allow_nil: true
    end

  end

  def organisation_name_or_user_name
    if self.is_organisation?
      self.organisation.name 
    else
      self.user.username
    end
  end

end
