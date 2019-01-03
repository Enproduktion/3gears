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

require 'rails_helper'

RSpec.describe Medium, :type => :model do
  context "Relations" do
    it { should belong_to(:referer) }
    it { should belong_to(:original) }
    it { should belong_to(:transcoding_preset) }
    it { should have_many(:transcodings) }
  end

  context "Validations" do
    it { should validate_presence_of(:medium_use) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:referer) }
  end
end
