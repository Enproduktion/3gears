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

RSpec.describe Footage, :type => :model do
  context "Attributes" do
    it { should respond_to :title }
    it { should respond_to :abstract }
    it { should respond_to :published }
    it { should respond_to :viewable_by_all }
    it { should respond_to :view_count }
    it { should respond_to :camera }
    it { should respond_to :lense }
    it { should respond_to :focal_distance }
    it { should respond_to :color }
    it { should respond_to :ratio }
    it { should respond_to :audio_recorder }
    it { should respond_to :audio_mixer }
    it { should respond_to :microphone }
    it { should respond_to :analog }
    it { should respond_to :film }
    it { should respond_to :speed }
    it { should respond_to :locale }
  end

  context "Relations" do
    it { should belong_to(:user) }
    it { should have_many(:crew_members) }
    it { should have_many(:tags) }
    it { should have_many(:notifications) }
    it { should have_many(:subscriptions) }
  end

  context "Validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:view_count) }
  end
end
