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

class MovieOrIdea < ActiveRecord::Base
  include LicenseHolder
  include IsCategorized
  include HasMedia
  include Viewable
  include Taggable

  default_value_for :budget_desc, ""
  default_value_for :abstract, ""
  default_value_for :synopsis, ""

  # Relations
  belongs_to :user
  belongs_to :organisation

  has_many :stuff,          as: :usedfor,   dependent: :destroy
  has_many :crew_members,   as: :work,      dependent: :destroy
  has_many :subscriptions,  as: :object,    dependent: :destroy
  has_many :specifications, as: :specable,  dependent: :destroy
  has_many :specs,          as: :specable,  class_name: 'Specification',  dependent: :destroy
  has_many :stills,         dependent: :destroy
  has_many :documents,      dependent: :destroy
  has_many :report_violations, as: :reportable, dependent: :destroy

  has_and_belongs_to_many :footage

  # Attachment
  has_attached_file :script,
    hash_secret: Rails.application.config.paperclip_secret,
    url: "/system/:class/:attachment/:id/:hash-:style.:extension",
    hash_data: ":class/:attachment/:id"

  validates :budget_needed, :budget_raised, :view_count, presence: true
  validates :title, :abstract, :budget_desc, :viewable_by_all, :is_idea,
    exclusion: {
      in: [nil],
      message: 'cannot be nil'
    }

  include OrganisationValidation

  validates_presence_of :title, if: :published?

  validates :budget_needed, :budget_raised,
    numericality: { greater_than_or_equal_to: 0 }

  validate do
    if is_idea_changed? && is_idea && !new_record?
      errors.add(:base, "cannot convert a movie to an idea")
    end
  end

  validates_attachment :script, content_type: {
    content_type: ["text/rtf", "text/plain", "application/pdf"]
  }

  include CheckAttachment

  # Scopes
  scope :only_published, -> { where.not(published_at: nil) }
  scope :only_public, -> { only_published.only_viewable_by_all }
  scope :ideas, -> { where(is_idea: true) }
  scope :movies, -> { where(is_idea: false) }
  scope :popular_first, -> { order("view_count DESC") }
  scope :latest_first,  -> { order(created_at: :desc) }

  default_scope { latest_first }

  include RealtimeIndice
  include QuickSearch

  #
  # Class methods
  #

  class << self
    def from_user(user)
      where(user_id: user.id)
    end

    def autocomplete_suggestions(term, limit, is_idea)
      MovieOrIdea.search(wildcard_and_escape_query(term), with: { is_idea: is_idea }, max_mathces: limit, match_mode: :any)
    end

    def quick_search(query, is_idea)
      text_title = (is_idea) ? "Idea" : "Movie"
      url_path   = (is_idea) ? "idea_path" : "movie_path"
      MovieOrIdea.default_quick_search(query, {url: url_path, field: 'title', title: text_title, is_idea: is_idea})
    end

    def get_creations(scope, ability)
      MovieOrIdea.accessible_by(ability).send(scope).includes(:user, :organisation)
    end
  end

  #
  # Instance methods
  #

  def search_in_same_category
    is_idea ? super.ideas : super.movies
  end

  def is_movie?
    !is_idea
  end

  # this will increase movie_or_idea view_count field
  #
  # movie_or_idea = MovieOrIdea.find(1)
  # movie_or_idea.view_count
  #   #=> 1
  # movie_or_idea.increase_view_count
  # movie_or_idea.view_count
  #   #=> 2
  #
  def increase_view_count
    self.view_count += 1
    self.save
  end

  def thumbnail
    medium_thumbnail
  end

  def header_image
    poster_image
  end

  def thumbnail_with_default
    thumbnail.exists? || !MovieOrIdea.default_movie_or_idea ? thumbnail : MovieOrIdea.default_movie_or_idea.thumbnail
  end

  def self.default_movie_or_idea
    User.default_user.movies_and_ideas.first
  end
end
