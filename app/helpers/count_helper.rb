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

module CountHelper
  def movie_footages_count(movie)
    movie.footage.accessible_by(current_ability).count
  end

  def movie_footages_duration(movie)
    movie.footage.accessible_by(current_ability).reduce(0) {|sum, f| sum + (f.try(:original).try(:duration)||0)}
  end

  def format_duration(media_duration)
    media_duration < 60.minutes ? (Time.mktime(0)+media_duration).strftime("%-Mmin") : (Time.mktime(0)+media_duration).strftime("%-Hh %-Mmin")
  end

  def format_duration_colon(media_duration)
    (Time.mktime(0)+media_duration).strftime("%H:%M:%S")
  end
end
