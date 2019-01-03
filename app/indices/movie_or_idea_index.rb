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

ThinkingSphinx::Index.define :movie_or_idea, :with => :real_time do

  indexes title, sortable: true
  indexes abstract
  indexes tag_names

  has user_id, type: :integer
  has is_idea, type: :integer
  has category_id, type: :integer
  has view_count, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
  has published_at, type: :timestamp, as: :date
end
