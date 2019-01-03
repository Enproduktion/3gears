
# Copyright (C) 2016 Enproduktion GmbH
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


class CreateReportViolations < ActiveRecord::Migration
  def change
    create_table :report_violations do |t|
      t.integer :report_type
      t.string :message
      t.references :reportable, polymorphic: true
      t.belongs_to :user
      t.timestamps
    end
    
    add_index :report_violations, [:reportable_id, :reportable_type]
    add_index :report_violations, :user_id
  end
end
