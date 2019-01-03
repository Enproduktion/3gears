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

class User < ActiveRecord::Base
  validates_length_of_login_field_options within: 2..30 # call this before "acts_as_authentic"!
  validates_format_of_login_field_options with: /\A[[:word:]]*\z/, message: I18n.t("error_messages.login_invalid")

  acts_as_authentic
  perishable_token_valid_for 1.week

  include LicenseHolder
  include Taggable

  default_value_for :abstract, ""

  # Relations
  has_many :movies_and_ideas, dependent: :destroy
  has_many :footage, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :occupations, as: :occupationable, dependent: :destroy
  has_many :as_member, class_name: "CrewMember", foreign_key: :user_id, dependent: :destroy
  has_many :project_occupations, class_name: "Occupation", through: :as_member, source: :occupations
  has_many :articles, dependent: :nullify
  has_many :organisations, dependent: :destroy

  has_many :user_organisations, dependent: :destroy

  has_and_belongs_to_many :movies_worked_for, class_name: "MovieOrIdea",
    join_table: :crew_members, association_foreign_key: :work_id

  # Attachment
  include Avatarable
  include Coverable

  has_attached_file :picture,
    styles: {
      big: { geometry: "464x261#",   format: :jpg, convert_options: "-quality 80 -interlace plane -interlace plane" }
    },
    url: "/system/:class/:attachment/:id/:style.:extension",
    default_url: ActionController::Base.helpers.asset_path("assets/picture/:style.jpg")

  validates :email, :username, :role, presence: true
  validates :confirmed, exclusion: { in: [nil], message: "cannot be nil" }

  validates_length_of :new_email, validates_length_of_email_field_options.merge(allow_nil: true)
  validates_format_of :new_email, validates_format_of_email_field_options.merge(allow_nil: true)

  validates_inclusion_of :new_email, in: [nil], unless: :new_email_token?
  validates_exclusion_of :new_email, in: [nil], if: :new_email_token?

  validate :new_email_not_in_email

  validates_attachment :picture, content_type: {
    content_type: ["image/jpeg", "image/png", "image/gif"]
  }

  include CheckAttachment

  # Scopes
  scope :newest_first, -> { order("created_at DESC") }

  after_save do
    if confirmed
      CrewMember.where(invited_email: email).update_all(user_id: id, invited_email: nil)
      Stuff.where(invited_email: email).update_all(supplier_id: id, invited_email: nil)
    end
    true
  end

  after_validation do
    if email_changed?
      User.where(new_email: email).update_all(new_email: nil, new_email_token: nil)
    end
    true
  end

  include RealtimeIndice
  include QuickSearch

  #
  # Class methods
  #
  class << self
    def find_by_username_or_email(login)
      where("LOWER(username) = LOWER(:login) OR LOWER(email) = LOWER(:login)", login: login).first
    end

    def find_using_new_email_token(token)
      return if token.blank?
      where(new_email_token: token).first
    end

    def default_user
      User.find_by_username("default")
    end

    def quick_search(query)
      User.default_quick_search(query, {url: 'user_path', field: 'username', title: 'User'})
    end
  end

  #
  # Instance metods
  #
  def to_param() username end

  # Roles
  #
  def editor?()       role == "editor" end
  def admin?()        role == "admin" end
  def user?()         role == "user" end
  def guest?()        role == "guest" || self.new_record? end

  # Request new email
  #
  def request_new_email(new_email)
    self.new_email = new_email
    self.new_email_token = Authlogic::Random.friendly_token
    save && AccountMailer.email_verification(self).deliver_now
  end

  # Confirm new email
  #
  def confirm_new_email
    self.email = new_email
    save!
  end

  def avatar_with_default
    avatar.exists? ? avatar : User.default_user.avatar
  end

  def picture_with_default
    picture.exists? ? picture : User.default_user.picture
  end

  # Return firstname and lastname
  # if firstname and lastname empty it will return username
  #
  def full_name
    if [self.first_name, self.last_name].join(' ').strip.empty?
      username
    else
      [self.first_name, self.last_name].join(' ')
    end
  end

  def name_with_username
    (self.first_name + ' "' + self.username + '" ' + self.last_name).strip
  end

  def zip_and_city
    [zip, city].join(' ')
  end

  # Return user occupations and occupation as crew
  #
  def user_occupations
    ( occupations + project_occupations ).uniq
  end

  def list_occupations
    user_occupations.map(&:occupation).uniq
  end

  def teammates
    get_teammates('all').group_by {|x| x}.sort_by {|x,list| [-list.size,x]}.map(&:first)
  end

  def footage_team
    get_teammates('only_footage')
  end

  def movies_or_ideas_team
    get_teammates('only_movies_or_ideas')
  end

  private

  def new_email_not_in_email
    if new_email_changed? and not User.where("LOWER(email) = LOWER(?)", new_email).empty?
      errors.add(:new_email, User.validates_uniqueness_of_email_field_options[:message])
    end
  end

  def get_teammates(scope_teammates)
    team = []
    self.as_member.send(scope_teammates).includes(:work).each do |value|
      value.work.crew_members.includes(:user).each do |crew_member|
        team << crew_member.user
      end
    end
    return team.flatten.delete_if{|x| x == self}
  end
end
