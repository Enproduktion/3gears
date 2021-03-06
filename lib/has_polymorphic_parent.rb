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

module HasPolymorphicParent
  extend ActiveSupport::Concern

  def find_polymorphic_parent
    possible_parents =
      [
          Article,
          Footage,
          MovieOrIdea,
          Organisation,
          User,
          CrewMember
      ]
    klass = possible_parents.detect { |c| params["#{c.name.underscore}_id"]}
    if klass.nil?
      return
    end
    klass.find(params["#{klass.name.underscore}_id"])
  end
end
