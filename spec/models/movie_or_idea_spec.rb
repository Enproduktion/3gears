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

RSpec.describe MovieOrIdea, :type => :model do
  context "Attributes" do
    it { should respond_to :title }
    it { should respond_to :abstract }
    it { should respond_to :budget_needed }
    it { should respond_to :budget_raised }
    it { should respond_to :budget_desc }
    it { should respond_to :flattr_id }
    it { should respond_to :published_at }
    it { should respond_to :view_count }
    it { should respond_to :viewable_by_all }
    it { should respond_to :is_idea }
  end

  context "Relations" do
    it { should belong_to(:user) }
    it { should have_many(:stuff) }
    it { should have_many(:crew_members) }
    it { should have_many(:tags) }
    it { should have_many(:subscriptions) }
    it { should have_many(:stills) }
  end

  context "Validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:budget_needed) }
    it { should validate_presence_of(:budget_raised) }
    it { should validate_presence_of(:view_count) }
  end
end
