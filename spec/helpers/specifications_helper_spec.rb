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

# Specs in this file have access to a helper object that includes
# the SpecsHelper. For example:
#
# describe SpecsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SpecificationsHelper, :type => :helper do
  describe "#link_to_spec" do
    before :each do
      @movie = MovieOrIdea.first
      @footage = Footage.first
    end

    it "should return movie_or_idea spec link" do
      expect(helper.link_to_spec(@movie, :en)).to include(movie_or_idea_specifications_path(locale: :en, movie_or_idea_id: @movie))
    end

    it "should return footage spec link" do
      expect(helper.link_to_spec(@footage, :en)).to include(footage_specifications_path(locale: :en, footage_id: @footage))
    end
  end
end
