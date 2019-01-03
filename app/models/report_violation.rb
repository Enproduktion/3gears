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

class ReportViolation < ActiveRecord::Base

  # 
  # Relations
  # 

  belongs_to :reportable, polymorphic: true
  belongs_to :user

  # 
  # Constant Variables
  # 

  REPORT_TYPE = { 
    "Abusive Content"     => 1,
    "Extremist Content"   => 2,
    "Porn"                => 3,
    "Rights Infringement" => 4,
    "Violent Content"     => 5
  }

  # 
  # Validations
  # 

  validates :user, presence: true
  validates :message, presence: true
  validates :report_type, presence: true
  validates :report_type, inclusion: { in: REPORT_TYPE.values }

  # 
  # [ ORDER QUERY ]
  # 
  if Frontend::is_order_query_available?
    include OrderQuery
    order_query :order_default,
      [:created_at, :desc]

  end

  # 
  # Instance Methods
  # 

  def report_name
    REPORT_TYPE.key(self.report_type)
  end

end
