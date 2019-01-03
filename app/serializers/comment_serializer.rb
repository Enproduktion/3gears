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

class CommentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :content, :standard_date, :username, :user_link, :avatar, :abuse_link

  has_one :user

  def standard_date
    object.created_at.strftime("%B %e, %Y")
  end

  def username
    user.username
  end

  def user_link
    user_path(:en, user)
  end

  def avatar
    user.avatar.url(:small)
  end

  def abuse_link
    abuse_comment_report_violations_path(comment_id: object.id, locale: :en)
  end
end
