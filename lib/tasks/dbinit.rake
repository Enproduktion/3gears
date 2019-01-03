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

namespace :db do
  task :init => :environment do
    TranscodingPreset.create!({
      name: "mobile",
      desc: "general",
      use: "streaming",
      settings: {
        transcoder: "ffmpeg",
        arguments: "-vf scale='1280:-1' -y -strict experimental -c:a libfaac -ab 192k -ar 48000 -ac 2 -vcodec libx264 -vprofile baseline -level 3 -b:v 1500k -f mp4",
      }.to_json,
      extension: "mp4",
      mime_type: "video/mp4",
      active: true,
    })
    TranscodingPreset.create!({
      name: "720p",
      desc: "",
      use: "download",
      settings: {
        transcoder: "ffmpeg",
        arguments: "-vf scale='1280:-1' -c:a mp2 -ab 384k -ar 48000 -ac 2 -vcodec mpeg2video -qscale 0 -f mpegts",
      }.to_json,
      extension: "mpg",
      active_above_height: 720,
      active: false,
    })
    TranscodingPreset.create!({
      name: "imagesequence",
      desc: "",
      use: "download",
      settings: {
        transcoder: "ffmpeg-sequence",
        arguments: "-an -f image2 -pix_fmt yuv422p10le",
        file_pattern: "%08d.j2k",
      }.to_json,
      extension: "",
      active: false,
    })
  end
end
