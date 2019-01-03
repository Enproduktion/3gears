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

class Article < ActiveRecord::Base
  include Viewable
  include Taggable

  # Relations
  belongs_to :user

  has_many :assets, -> { order :position }, dependent: :destroy
  has_many :article_contents, dependent: :destroy

  # Validations
  validates :view_count, :user, presence: true

  # 
  # Scope
  # 
  scope :only_published, -> { where.not(published_at: nil) }
  scope :newest_first, -> { order(:published_at) }

  include RealtimeIndice

  # 
  # Class methods
  # 
  class << self
    def only_with_locale(locale)
      joins(:article_contents).where("article_contents.locale" => locale).where("article_contents.title != ''").uniq
    end

    def get_articles(current_ability)
      Article
        .accessible_by(current_ability)
        .recently_published_first
    end
  end
  
  # 
  # Instance methods
  # 

  # get first asset for cover
  def cover_image
    assets.first
  end

  def secondary_images
    assets.offset(1)
  end

  def content(locale)
    @content ||= {}
    @content[locale] ||=
      article_contents.find_by_locale(locale) ||
      article_contents.build({
        article: self,
        locale: locale,
      })
  end

  def shown_locale(preferred_locale)
    content(preferred_locale).title.empty? ? I18n.default_locale : preferred_locale
  end

  def title(preferred_locale)
    title = content(preferred_locale).title
    title.empty? ? content(I18n.default_locale).title : title
  end

  def abstract(preferred_locale)
    abstract = content(preferred_locale).abstract
    abstract.empty? ? content(I18n.default_locale).abstract : abstract
  end

  def body(preferred_locale)
    body = content(preferred_locale).body
    body.empty? ? content(I18n.default_locale).body : body
  end

  def increase_view_count
    self.view_count += 1
    self.save
  end

  def prev_article
    self.class.where(["id < ?", id]).last
  end

  def next_article
    self.class.where(["id > ?", id]).first
  end
end
