
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


class CreateOrganisations < ActiveRecord::Migration
  def up
    create_table :organisations do |t|
      t.references :user
      t.string :name
      t.attachment :avatar
      t.string :token
      t.boolean :confirmed, default: false
      t.timestamps
    end

    # Add organisation to footage, movie and idea
    add_reference :footage, :organisation, index: true
    add_column    :footage, :is_organisation, :boolean, default: false
    add_reference :movies_and_ideas, :organisation, index: true
    add_column    :movies_and_ideas, :is_organisation, :boolean, default: false
  end

  def down
    drop_table :organisations
    remove_reference :footage, :organisation
    remove_reference :movies_and_ideas, :organisation
    remove_column :footage, :is_organisation
    remove_column :movies_and_ideas, :is_organisation
  end
end
