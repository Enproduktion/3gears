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

class Footage < ActiveRecord::Base
  include LicenseHolder
  include IsCategorized
  include HasMedia
  include Viewable
  include Taggable

  default_value_for :abstract, ""
  default_value_for :synopsis, ""
  default_value_for :user_id, nil

  # Relations
  belongs_to :user
  belongs_to :organisation
  has_many :crew_members, as: :work, dependent: :destroy
  has_many :notifications,  as: :object, dependent: :destroy
  has_many :subscriptions,  as: :object, dependent: :destroy
  has_many :specifications, as: :specable,  dependent: :destroy
  has_many :specs,          as: :specable,  class_name: 'Specification',  dependent: :destroy
  has_many :report_violations, as: :reportable, dependent: :destroy
  has_one :footage_metadatum, dependent: :destroy

  has_and_belongs_to_many :movies_and_ideas, class_name: "MovieOrIdea"


  include OrganisationValidation

  validates :view_count, presence: true
  validates :title, :abstract, :viewable_by_all,
    exclusion: { in: [nil], message: "cannot be nil" }
  validates :title, presence: true, if: :published?

  # Scopes
  scope :only_published, -> { where.not(published_at: nil) }
  scope :only_public, -> { only_published.only_viewable_by_all }
  scope :popular_first, -> { order("view_count DESC") }

  include RealtimeIndice
  include QuickSearch

  has_attached_file :caption,
                    hash_secret: Rails.application.config.paperclip_secret,
                    url: "/system/:class/:attachment/:id/:hash-:style.:extension"
  validates_attachment_file_name :caption, :matches => [/vtt\Z/]


  #
  # Class methods
  #
  class << self
    def min_year
      1945
    end

    def max_year
      2016
    end
    
    def from_user(user)
      where(user_id: user.id)
    end

    def quick_search(query)
      Footage.default_quick_search(query, {url: 'footage_path', field: 'title', title: 'Footage'})
    end
  end

  #
  # Instance methods
  #

  # this will increase footage view_count field
  #
  # footage = Footage.find(1)
  # footage.view_count
  #   #=> 1
  # footage.increase_view_count
  # footage.view_count
  #   #=> 2
  #
  def increase_view_count
    self.view_count += 1
    self.save
  end

  def thumbnail
    medium_thumbnail
  end

  def tagged_years
    original.tags.map do |tag|
      tag.to_year_i # only years. naive implementation until we have a better tag input system for this
    end.compact
  end

  def media_time_tag_tag_ids
    original.tags.map(&:id).compact + tag_ids.compact
  end
  
  def thumbnail_with_default
    thumbnail.exists? || !Footage.default_footage ? thumbnail : Footage.default_footage.thumbnail
  end

  def media_duration
    media = self.media.where.not(duration: nil).first
    media ? media.duration.seconds : 0.0.seconds
  end

  def self.default_footage
    User.default_user.footage.first
  end

  def export_id
    "AVA:#{self.id}"
  end
end
