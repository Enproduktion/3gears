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

ThinkingSphinx::Index.define :article, :with => :real_time do
  where "published"

  indexes article_contents.title, sortable: true, as: :titles
  indexes article_contents.abstract, as: :abstracts
  indexes article_contents.body, as: :bodies
  indexes tag_names
  
  has view_count, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
  has published_at, type: :timestamp, as: :date
end
