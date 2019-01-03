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

class FootageMetadatum < ActiveRecord::Base
  belongs_to :footage

  AVAILABLE_GENRES = [
    'Interview',
    'Audio only',
    'Historical footage',
    'Ephemeral footage',
    'Miscellaneous'
  ]

  after_save :update_search_index

  def update_search_index
    ThinkingSphinx::RealTime::Callbacks::RealTimeCallbacks.new(:footage).after_save(footage)
  end
  
  def fill_from_jsonld(json)
    self.country = json.fetch('countryOfOrigin', {})['name']
    self.cast = json.fetch('cast', []).map{|x| x['name'].strip}.join(', ')
    self.citations = json.fetch('citation', []).map{|x| x['name'].strip}.join(', ')
    self.source = json.fetch('source', {})['name']
    self.original_format = json['videoFormat']
    self.original_length = json['distance']
    self.genre = json['genre']
    self.original_language = json['inLanguage']
    self.year_of_reference = json['datePublished']
  end
end
