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

RSpec.describe Document, :type => :model do

  context "Relations" do
    it { should belong_to(:movie_or_idea) }
  end

  context "Attachments" do
    it { should respond_to :document_content_type }
    it { should respond_to :document_file_name }
    it { should respond_to :document_file_size }
    it { should respond_to :document_updated_at }

    it { should have_attached_file(:document) }
    it { should validate_attachment_presence(:document) }
    it { should validate_attachment_content_type(:document).
                  allowing("application/vnd.oasis.opendocument.text", "application/vnd.ms-excel", "text/rtf", "text/plain", "application/pdf") }
  end
end
