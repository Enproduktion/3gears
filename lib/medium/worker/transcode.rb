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

class Medium::Worker::Transcode
  @queue = :medium

  def self.perform(original_medium_id, presets)
    original_medium = Medium.find(original_medium_id)

    jobs = presets.map do |preset|
      { destination: "transcoded", settings: JSON.parse(preset["settings"]) }
    end

    statuses = MediaFileserver.transcode(original_medium.fileserver_handle, jobs)

    statuses.map do |status|
      preset = presets.shift

      medium = Medium.new(
        {
          original: original_medium,
          original_filename: original_medium.original_filename,
          referer: original_medium.referer,
          medium_use: preset["use"],
          transcoding_preset_id: preset["id"],
          transcoder_settings: preset["settings"],
        }, without_protection: true
      )

      if status[:started]
        medium.fileserver_handle = status[:id]
        medium.status = "transcoding"
      else
        medium.status = "transcoding_failed"
        medium.transcoding_error = status[:message]
      end

      medium.save!
    end
  end
end
