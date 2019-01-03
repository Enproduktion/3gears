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

module ThreeGearsHelper
  def render_mobile_comment(object)
    render partial: "comments/mobile_comment_area", locals: { commentable: object }
  end

  def render_mobile_share(object)
    render partial: "shariff/mobile_share_area", locals: { shareable: object }
  end

  def render_mobile_visibility(object)
    render partial: "partials/visibility_mobile", locals: { object: object }
  end

  def render_mobile_preference(user)
    render partial: "users/preferences", locals: { user: user }
  end

  def render_mobile_violation(object)
    render partial: "report_violations/report", locals: { reportable: object }
  end

  def text_navigation
    @navigation_text.nil? ? 'MENU' : @navigation_text
  end

  def full_text_navigation
    "3G < #{text_navigation}"
  end
end
