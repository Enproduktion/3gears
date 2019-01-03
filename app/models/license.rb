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

class License < ActiveRecord::Base
  default_value_for :holder_address, ""

  # Relations
  belongs_to :material, polymorphic: true

  # Validations
  validates :material, presence: true
  validates :holder_name, :holder_email, :holder_address,
    exclusion: {
      in: [nil],
      message: 'cannot be nil'
    }

  before_validation do
    if preset_name != "custom"
      self.custom_license_name = nil
      self.custom_license_url = nil
    else
      self.custom_license_name = "" if custom_license_name.nil?
      self.custom_license_url = "" if custom_license_url.nil?

      if not custom_license_url.empty? and not custom_license_url =~ %r{^https?://}
        self.custom_license_url = "http://#{custom_license_url}"
      end
    end
    true
  end

  class << self
    def preset_names
      [
        "CC_BY",
        "CC_BY_ND",
        "CC_BY_NC_SA",
        "CC_BY_SA",
        "CC_BY_NC",
        "CC_BY_NC_ND"
      ]
    end
  end
end
