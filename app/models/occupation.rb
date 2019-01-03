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

class Occupation < ActiveRecord::Base
  # 
  # Relations
  # 
  belongs_to :occupationable, polymorphic: true

  # 
  # Validations
  # 
  validates :occupation, :occupationable, presence: true
  validates_uniqueness_of :occupation, scope: [:occupationable_id, :occupationable_type]

  # 
  # Class methods
  # 
  class << self
    def autocomplete_suggestions(term, count)
      limit = sanitize(count)
      Occupation.select(:occupation).group(:occupation)
         .where("occupation LIKE ?", "#{term}%")
         .limit(limit).count
    end

    def types
      {
        most_used: %w(camera sound light editing postproduction interviewer production pa director research projectmgmt)
      }
    end

    def default_occupations
      Occupation.types[:most_used]
    end

    def all_occupations
      default_occupations
    end
  end
end
