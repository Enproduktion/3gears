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

module OrganisationsHelper
  def image_project_organisation_or_user(project, size = :small)
    if project.is_organisation?
      image_path = project.organisation.avatar(size)
    else
      image_path = project.user.avatar(size)
    end
    image_tag image_path
  end

  def link_to_organisation(organisation, html_options = {})
    link_to organisation.name, build_organisation_link(organisation)
  end

  def link_to_organisation_or_user(project, html_options = {})
    if project.is_organisation?
      link_to_organisation(project.organisation, html_options)
    else
      link_to_user(project.user, html_options)
    end
  end

  private
  def is_owner_organisation(organisation)
    organisation.user == current_user
  end

  def build_organisation_link(organisation)
    if is_owner_organisation(organisation)
      edit_organisation_path(organisation)
    else
      organisation_path(organisation)
    end
  end
end
