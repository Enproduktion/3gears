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

ThinkingSphinx::Index.define :user, :with => :real_time do
  where "confirmed AND NOT hidden"

  indexes username, sortable: true
  indexes abstract, first_name, last_name
  indexes tag_names

  has field_of_work, type: :string
  has language, type: :string
  has created_at, type: :timestamp, as: :date
end
