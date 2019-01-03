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

module ArticleDoxMethods
  module Article

    # 
    # get article content by locale
    # if article for locale not found
    # will create new article content by locale
    # 
    def content(locale)
      @content ||= {}
      @content[locale] ||=
        article_contents.find_by_locale(locale) ||
        article_contents.build({
          article: self,
          locale: locale,
        })
    end

    # 
    # get article title by locale
    # 
    def title(preferred_locale)
      title = content(preferred_locale).title
      title.empty? ? content(I18n.default_locale).title : title
    end

    # 
    # get article abstract by locale
    # 
    def abstract(preferred_locale)
      abstract = content(preferred_locale).abstract
      abstract.empty? ? content(I18n.default_locale).abstract : abstract
    end

    # 
    # get article body by locale
    # 
    def body(preferred_locale)
      body = content(preferred_locale).body
      body.empty? ? content(I18n.default_locale).body : body
    end

    # 
    # increase view count if article viewed
    # 
    def increase_view_count
      self.view_count += 1
      self.save
    end

  end

  module ArticleContent
    def self.by_locale(locale)
      where(locale: locale)
    end
  end
end
