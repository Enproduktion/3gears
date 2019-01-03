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

class TranscodingPreset < ActiveRecord::Base
  # Scopes
  scope :only_active, -> { where(active: true) }

  # 
  # Class methods
  # 
  class << self
    def reasonable_for(movie)
      only_active.all.to_a.keep_if do |preset|
        next true if !preset.active_above_height || !movie.height
        movie.height > preset.active_above_height
      end
    end
  end
end
