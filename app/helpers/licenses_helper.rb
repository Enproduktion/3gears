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

module LicensesHelper
  def render_license_area_for(license_holder, options = nil)
    options ||= { }
    template = (options[:template].nil?) ? 'license' : options[:template]
    render partial: "licenses/#{template}", locals: {
      license: license_holder.license,
      editable: options[:editable],
    }
  end

  def license_choices
    @license_choices ||= build_license_choices
  end

  private

  def build_license_choices
    choices = [
      [t("license.creative_commons"), License.preset_names],
    ]

    choices = translate_select_choices(choices, "license.preset.names")

    choices << [t("license.custom"), [[t("license.custom"), "custom"]]]
  end
end
