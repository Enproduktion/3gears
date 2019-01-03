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

module VideoHelper
  def display_video(medium, editable, streaming_media, download_media, initial_annotation_id, more_options)
    options = {
      "preload" => "auto",
      "controls" => true,
      "data-setup" => "{}",
    }

    options.merge!(more_options.stringify_keys) if more_options
    options.merge!(
        id: "medium_#{medium.id}",
        data: {user: editable ? '1' : '0' },
        class: "video-js #{options["class"]}".strip,
    )

    containerClass = "#{editable ? '' : 'readonly'}".strip

    render partial: "media/video", locals: {
        medium: medium,
        streaming_media: streaming_media,
        download_media: download_media,
        options: options,
        container_class: containerClass,
        initial_annotation_id: initial_annotation_id}
  end
end
