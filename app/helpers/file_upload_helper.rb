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

module FileUploadHelper
  def file_upload(path, name, more_options = nil)
    options = { "remote" => true, "multipart" => true }

    options.merge!(more_options.stringify_keys) if more_options
    options.merge!("class" => "file-upload #{options["class"]}".strip)

    more_input_options = options.delete("input")

    input_options = { "type" => "file", "name" => name }
    input_options.merge!(more_input_options.stringify_keys) if more_input_options

    form_tag(path, options) do
      tag("input", input_options)
    end
  end
end
