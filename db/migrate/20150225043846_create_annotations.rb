
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


class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :media
      t.string :uri
      t.text :text
      t.string :ranges, array: true, default: "{}"
      t.references :user
      t.float :start
      t.float :end
      t.string :src
      t.string :ext
      t.string :container
      t.float :longitude
      t.float :latitude
      t.float :altitude
      t.float :accuracy
      t.string :read, array: true, default: "{}"
      t.string :admin, array: true, default: "{}"
      t.string :can_update, array: true, default: "{}"
      t.string :can_delete, array: true, default: "{}"
      
      t.timestamps
    end
  end
end
