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

ThinkingSphinx::Index.define :footage, :with => :real_time do

  indexes title, sortable: true
  indexes abstract
  indexes tag_names
  indexes footage_metadatum.country
  indexes footage_metadatum.cast
  indexes footage_metadatum.original_format
  indexes footage_metadatum.original_language
  indexes footage_metadatum.year_of_reference
  indexes footage_metadatum.genre
  indexes footage_metadatum.citations
  indexes footage_metadatum.source

  indexes camera, lense, color, ratio, audio_recorder, audio_mixer, microphone, film

  has user_id, type: :integer
  has category_id, type: :integer
  has view_count, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
  has published_at, type: :timestamp, as: :date
  has tag_ids, type: :integer, multi: true
  has media_time_tag_tag_ids, type: :integer, multi: true
  has movie_or_idea_ids, type: :integer, multi: true
  has tagged_years, type: :integer, multi: true
end
