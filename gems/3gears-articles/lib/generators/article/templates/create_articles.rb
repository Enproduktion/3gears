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

class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.boolean :published, default: false, null: false
      t.datetime :published_at
      t.integer :view_count, default: 0, null: false
      t.timestamps
    end

    add_index :articles, :published
    add_index :articles, :view_count

    create_table :article_contents do |t|
      t.string :locale, null: false
      t.string :title, default: ""
      t.text :abstract
      t.text :body
    end
  end

  def self.down
    drop_table :articles
    drop_table :article_contents
  end
end
