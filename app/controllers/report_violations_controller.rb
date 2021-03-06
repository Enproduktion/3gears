# Copyright (C) 2017 Enproduktion GmbH
# This file is part of 3gears.

# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class ReportViolationsController < ApplicationController
  include HasPolymorphicParent
  before_filter { @reportable = find_polymorphic_parent }
  authorize_resource :reportable
  load_and_authorize_resource :report_violation, through: :reportable

  theme Frontend::APP_STYLE, only: [:abuse] unless Frontend.is_empty_style?

  def create
    @report_violation.user = current_user

    if @report_violation.save
      ViolationMailer.send_violation_notification(@report_violation).deliver_now
      respond_created_and_render_text
    else
      render_errors(@report_violation, :unprocessable_entity)
    end
  end

  def abuse
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def create_params
    params.require(:report_violation).permit(:report_type, :message)
  end
end
