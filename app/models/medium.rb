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

class Medium < ActiveRecord::Base
  include FileserverActions

  # Relations
  belongs_to :referer, polymorphic: true
  belongs_to :original, class_name: "Medium"
  belongs_to :transcoding_preset

  has_many :transcodings, foreign_key: :original_id, class_name: "Medium", dependent: :destroy
  has_many :medium_time_tags, dependent: :destroy
  has_many :tags, through: :medium_time_tags

  # Attachment
  has_attached_file :thumbnail,
    styles: lambda { |attachment| attachment.instance.thumbnail_styles },
    hash_secret: Rails.application.config.paperclip_secret,
    url: "/system/:class/:attachment/:id/:hash-:style.:extension",
    hash_data: ":class/:attachment/:id"

  validates_presence_of :medium_use, :status, :referer

  validates_attachment :thumbnail, content_type: {
    content_type: ["image/jpeg", "image/png", "image/gif"]
  }

  include CheckAttachment

  # Scopes
  scope :only_originals, -> { where(medium_use: "original") }
  scope :only_for_download, -> { where(medium_use: "download") }
  scope :only_for_streaming, -> { where(medium_use: "streaming") }
  scope :only_for_thumbnails, -> { where(medium_use: "thumbnails") }

  # tabula_rasa -> uploading -> upload_finishing -> upload_finished -> published
  # tabula_rasa -> transcoding -> transcoding_finished -> published
  # tabula_rasa -> transcoding -> transcoding_failed

  scope :tabula_rasa, -> { where(status: "tabula_rasa") }
  scope :uploading, -> { where(status: "uploading") }
  scope :upload_finishing, -> { where(status: "upload_finishing") }
  scope :upload_finished, -> { where(status: "upload_finished") }
  scope :transcoding, -> { where(status: "transcoding") }
  scope :transcoding_finished, -> { where(status: "transcoding_finished") }
  scope :transcoding_failed, -> { where(status: "transcoding_failed") }
  scope :published, -> { where(status: "published") }

  # 
  # Instance methods
  # 

  def original?() medium_use == "original" end
  def for_download?() medium_use == "download" end
  def for_streaming?() medium_use == "streaming" end
  def for_thumbnails?() medium_use == "thumbnails" end

  def tabula_rasa?() status == "tabula_rasa" end
  def uploading?() status == "uploading" end
  def upload_finished?() status == "upload_finished" end
  def upload_finishing?() status == "upload_finishing" end
  def transcoding?() status == "transcoding" end
  def transcoding_finished?() return status == "transcoding_finished" end
  def transcoding_failed?() status == "transcoding_failed" end
  def published?() status == "published" end
  def ready?() published? || transcoding_finished? || upload_finished? end

  def upload_url
    fileserver_handle && MediaFileserver.upload_url_for(fileserver_handle)
  end

  def public_path
    public_name && MediaFileserver.public_url_for(fileserver_handle, public_name)
  end

  def s3_path
    public_name && MediaFileserver.s3_url_for(fileserver_handle, public_name)
  end

  def mime_type
    (transcoding_preset && transcoding_preset.mime_type) || 'video/mp4'
  end

  def pick_random_thumbnail
    set_random_thumbnail
    save!
    update_thumbnail

    transcodings.where("medium_use != 'thumbnails'").each do |transcoding|
      transcoding.update_thumbnail
    end
  end

  def streaming_ready?
    !transcodings.only_for_streaming.published.empty?
  end

  def thumbnails_ready?
    !transcodings.only_for_thumbnails.published.empty?
  end

  before_destroy do
    delete_from_server
    true
  end

  def thumbnail_styles
    styles = {
      preview: { geometry: "", convert_options: "-crop 76%x+0+0 -gravity Center -crop 128x72+0+0 +repage" },
    }

    if original?
      styles.merge!({
        poster: {
          geometry: "1280 x 720",
          convert_options: "-background black -gravity center -extent 1280 x 720"
        },
        small: { geometry: "32x18#", format: :jpg, convert_options: "-quality 80 -interlace plane" }, # thumb for headline
        medium: { geometry: "128x72#", format: :jpg, convert_options: "-quality 80 -interlace plane" }, # standardsize (index, rightcolumn)
      })
    end

    styles
  end

  def get_status
    if self.streaming_ready?
      self.status
    else
      'transcoding'
    end  
  end

  private

  def set_random_thumbnail
    self.thumbnail_index = Random.rand(1..50)
  end
end
