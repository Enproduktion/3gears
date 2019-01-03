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

RSpec.describe Organisation, :type => :model do
  context "Attributes" do 
    it { should respond_to :name }
    it { should respond_to :token }
    it { should respond_to :confirmed }
    it { should respond_to :abstract }
    it { should respond_to :email }
    it { should respond_to :country }
    it { should respond_to :zip }
    it { should respond_to :city }
    it { should respond_to :first_address }
    it { should respond_to :second_address }
  end

  context "Relations" do
    it { should belong_to(:user) }
  end

  context "Attachments" do
    it { should respond_to :avatar_content_type }
    it { should respond_to :avatar_file_name }
    it { should respond_to :avatar_file_size }
    it { should respond_to :avatar_updated_at }
  end

  context "Validations" do
    it { should validate_presence_of(:user) }
  end
end
