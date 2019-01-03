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

class Ability
  include CanCan::Ability

  def initialize(user, organisation = nil)
    user ||= User.new
    organisation ||= Organisation.new
    @user = user
    @organisation = organisation

    if user.guest?
      guest_ability
    else
      # 
      # Admin
      # 

      if user.admin?
        can :manage, :all
        return
      end

      # 
      # Editor
      # 

      if user.editor?
        can :manage, Article
        can :manage, ArticleContent
        can :manage, Asset
      end

      # 
      # User
      # 

      # Can act as an organisation and logout
      can [:update, :destroy], :user_session

      # Can Change Password
      can :manage, :account_password

      # Can edit email
      can [:edit, :update], :account_email

      # Can manage account
      can [:show, :edit, :update, :destroy], :account

      # Can report movie, idea, or footage
      can [:create, :abuse], ReportViolation

      user_loggedin_ability

      # Publication Entry
      can :read, PublicationEntry, PublicationEntry.viewable_by(user) do |publication_entry|
        publication_entry.viewable_by?(user)
      end

      # Medium
      can :read, Medium
      can :manage, Medium do |medium|
        can?(:update, medium.referer)
      end

      # Still
      can :manage, Still do |still|
        can?(:update, still.movie_or_idea)
      end

      # Stuff
      can :manage, Stuff do |stuff|
        can?(:update, stuff.usedfor)
      end

      # Have access to notification
      can [:read, :update], Notification, user_id: user.id

      # License
      can :update, License do |license|
        can?(:update, license.material)
      end

    end

    same_ability_guest_and_user
  end

  # 
  # Ability Guest and User
  # 
  def same_ability_guest_and_user
    # Can Search
    can [:show, :quick_search], :search

    # Can show media
    can :read, Medium

    # Can show media tags
    can :read, MediumTimeTag

    # Can see user detail
    can :read, User, confirmed: true

    # Can read articles
    can :read, Article, viewable_by_all: 2

    # Movie or Idea
    movie_or_idea_ability

    # Footage
    footage_ability

    # User
    ability_for_user

    # Can read organisations
    can :read, Organisation

    # Can read stills
    can :read, Still

    # Can read documents
    can :download, Document do |document|
        can? :read, document.movie_or_idea
    end
  end

  # 
  # Ability for Movie or Idea
  # 
  def movie_or_idea_ability
    # Can read Movie or Idea when viewable
    can :read, MovieOrIdea, MovieOrIdea.viewable_by(@user, @organisation) do |movie_or_idea|
      movie_or_idea.viewable_by?(@user, @organisation)
    end

    # Can create Movie or Idea if registered
    can :create, MovieOrIdea unless @user.guest?

    # Can update if Movie or Idea owner
    can [:update, :finalize, :delete_script, :destroy], MovieOrIdea do |movie_or_idea|
      movie_or_idea.is_organisation? ? movie_or_idea.organisation_id == @organisation.id : movie_or_idea.user_id == @user.id
    end

    # Can convert idea to movie only for idea
    can :make_movie, MovieOrIdea do |movie_or_idea|
      movie_or_idea.is_idea && can?(:update, movie_or_idea)
    end
  end

  # 
  # Ability for Footage
  # 
  def footage_ability
    # Can read Footage when viewable
    can :read, Footage, Footage.viewable_by(@user, @organisation) do |footage|
      footage.viewable_by?(@user, @organisation)
    end

    # Can create Footage if registered
    can :create, Footage unless @user.guest?

    # Can update if footage's owner 
    can [:update, :destroy], Footage do |footage|
      footage.is_organisation? ? footage.organisation_id == @organisation.id : footage.user_id == @user.id
    end

    can [:update], FootageMetadatum do |footage_metadatum|
      footage_metadatum.footage.is_organisation? ? footage_metadatum.footage.organisation_id == @organisation.id : footage_metadatum.footage.user_id == @user.id
    end
  end

  # 
  # Ability for User
  # 
  def ability_for_user
    # Can read confirmed user
    can :read, User, confirmed: true

    # Can update details if user's owner
    can [:update, :destroy], User, id: @user.id

    # Can suggest user if registered
    can :suggest, User unless @user.guest?
  end

  #
  # Ability for Tag
  #
  def ability_for_tag
    can :create, Tag unless @user.guest?
    can :suggest, Tag unless @user.guest?
  end

  #
  # Ability for TagReference
  #
  def ability_for_tag_reference
    can :manage, TagReference do |tag_reference|
      can?(:update, tag_reference.taggable)
    end
  end

  #
  # Ability for MediumTimeTag
  #
  def ability_for_medium_time_tag
    can :read, MediumTimeTag
    can :manage, MediumTimeTag do |medium_time_tag|
      can?(:update, medium_time_tag.medium)
    end
  end

  # 
  # Ability for Organisation
  # 
  def ability_for_organisation
    can [:create, :clear, :read, :confirm], Organisation
    can [:update, :destroy, :use], Organisation do |organisation|
      organisation.user == @user && organisation.confirmed?
    end
    can :manage, UserOrganisation do |user_organisation|
      user_organisation.organisation.has_member?(@user)
    end
  end

  # 
  # Ability for Specification
  # 
  def ability_for_specification
    can :manage, Specification do |spec|
      can?(:update, spec.specable)
    end
  end

  # 
  # Ability for CrewMember
  # 
  def ability_for_crew_member
    can :manage, CrewMember do |crew_member|
      crew_member.user == @user || can?(:update, crew_member.work)
    end
  end

  # 
  # Ability for Document
  # 
  def ability_for_document
    can [:manage], Document do |document|
      can?(:update, document.movie_or_idea)
    end
  end

  # 
  # Ability for Occupation
  # 
  def ability_for_occupation
    can :manage, Occupation do |occupation|
      can? :update, occupation.occupationable
    end
  end

  # 
  # User Loggedin ability
  # 
  def user_loggedin_ability
    ability_for_crew_member
    ability_for_document
    ability_for_occupation
    ability_for_organisation
    ability_for_specification
    ability_for_tag
    ability_for_tag_reference
    ability_for_medium_time_tag
  end

  # 
  # Guest ability
  # 
  def guest_ability
    # Can Login
    can [:new, :create, :destroy], :user_session

    # Can reset password
    can :manage, :account_password_reset

    # Can confirm email
    can :confirm, :account_email

    # Can sign up
    can [:new, :create, :confirm], :account
  end
end
