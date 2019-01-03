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

module LicenseHolder
  extend ActiveSupport::Concern

  included do
    has_one :license, as: :material, dependent: :destroy, autosave: true

    validates_associated :license

    delegate :license_name, :custom_license_name, :custom_license_url, to: :license
    delegate :holder_name, :holder_email, :holder_address,
             to: :license, prefix: true

    before_validation do
      build_license({ material: self }) unless license
      true
    end
  end

  def license_name=(license_name)
    self.license ||= License.new
    license.license_name = license_name
  end

  def license_holder_name=(holder_name)
    self.license ||= License.new
    license.holder_name = holder_name
  end

  def license_holder_address=(holder_address)
    self.license ||= License.new
    license.holder_address = holder_address
  end

  def license_holder_email=(holder_email)
    self.license ||= License.new
    license.holder_email = holder_email
  end

  def custom_license_name=(custom_license_name)
    self.license ||= License.new
    license.custom_license_name = custom_license_name
  end

  def custom_license_url=(custom_license_url)
    self.license ||= License.new
    license.custom_license_url = custom_license_url
  end
end
