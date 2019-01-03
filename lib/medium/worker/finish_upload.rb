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

class Medium::Worker::FinishUpload
  @queue = :medium

  def self.perform(medium_id)
    medium = Medium.find(medium_id)
    medium.upload_finishing? or return

    MediaFileserver.move_to(medium.fileserver_handle, "originals")
    medium.status = "upload_finished"
    medium.save!

    medium.publish

    medium.request_medium_info
    presets = TranscodingPreset.reasonable_for(medium)

    medium.transcode(presets)
    medium.generate_thumbnails
  end
end
