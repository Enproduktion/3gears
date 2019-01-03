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

Frontend::Application.routes.draw do

  supported_locales = Rails.application.config.supported_locales
  allowed_locales_regexp = Regexp.new(supported_locales.join "|")

  scope ":locale", locale: allowed_locales_regexp do
    get "" => "frontpage#index", as: "localized_root"
    resources :articles do
      resources :tag_references
      resources :assets do
        post :move_up
        post :move_down
      end
      put "contents/:content_locale" => "article_contents#update", as: "content"
    end

    get "/pages/:id" => "pages#show", :as => :page, :format => false

    get "login" => "user_sessions#new", as: "new_user_session"
    put "switch_perspective" => "user_sessions#update", as: "update_user_session"
    resource :user_session

    resource :account, controller: :account do
      get "confirm/:confirmation_code" => "account#confirm", as: "confirm"
      resource :email, controller: :account_email do
        get "confirm/:confirmation_code" => "account_email#confirm", as: "confirm"
      end
      resource :password, controller: :account_password
      resource :password_reset, controller: :account_password_reset

      resources :notifications
      resources :feeds
    end

    resources :uploads

    resources :footage, except: :index do
      resources :report_violations, only: [:create] do
        collection do
          get :abuse
        end
      end

      get 'annotation/:annotation_id' => "footage#show", as: :annotation

      resources :tag_references
      resources :crew_members
      post :add_to_movie, action: :add_to_movie
      delete :remove_from_movie, action: :remove_from_movie
      resource :subscriptions
      resources :specifications
    end

    resources :footage_metadatum, only: [:update] do
      member do
        patch 'file_upload'
      end
    end

    resources :ideas, except: :index, as_idea: true, controller: :movies_and_ideas do
      get :finalize
      post :make_movie
    end
    resources :movies, except: :index, as_idea: false, controller: :movies_and_ideas, path: 'collections'

    resources :movies_and_ideas do
      resources :report_violations, only: [:create] do
        collection do
          get :abuse
        end
      end
      resources :tag_references
      resources :crew_members do
        resources :occupations
      end
      resources :stills
      resources :stuff
      delete :script, action: :delete_script, as: "script"
      resource :subscriptions
      resources :documents do
        member do
          get :index
          get :download
        end
      end
      resources :specifications
    end

    get ":type(/f/:first)(/p/:page)" => "creations#index", type: /footage|ideas|movies|all/, as: "creations"
    post "/creations" => "creations#create", as: "new_creation"

    resources :organisations do
      resources :occupations
      member do
        post :use
      end
      collection do
        get "confirm/:confirmation_code" => "organisations#confirm", as: "confirm"
        post :clear
      end
    end

    resources :users do
      get ":type(/:page)" => "creations#index", type: /all|footage|ideas|movies/, as: "creations"
      resources :tag_references, parent_find_by: :username
      resources :occupations, parent_find_by: :username
      collection do
        get :suggest
      end
    end

    resources :crew_members do
      resources :occupations
    end

    resources :media do
      post :thumbnail, action: :pick_thumbnail
      get :status

      resources :medium_time_tags, only: [:index, :create, :update, :destroy], defaults: { format: :json }

    end

    resources :tags, only: [] do
      collection do
        get :suggest
      end
    end

    resources :licenses

    resources :documents, only: [:update]

    resource :invitation, only: [:new, :create]

    get "search(/:type)" => "search#show",
        type: /movies|ideas|footage|articles/, as: "search"

    get "quick-search" => "search#quick_search", as: "quick_search"

    # User Organisations
    resources :user_organisations, only: [:create, :destroy]

    post "share/email" => "share#email", as: "email_share"

    post "recover" => "account_password_reset#recover", as: "recover_password"

  end

  # Feedback
  resources :feedbacks, only: [:create]

  # Social Sharing
  get "shariff", to: "shariff#shariff", as: :shariff

  mount ShariffBackend::App, at: '/share'

  root to: "language#index"
end
