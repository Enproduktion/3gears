# Copyright (C) 2017 Enproduktion GmbH
# This file is part of 3gears.

# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    set_locale
    @unread_notifications =
      current_user && Notification.only_unread.from_user(current_user).count
  end

  # Set locale for 3dox application
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def url_options
    super.merge(locale: I18n.locale)
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_organisation)
  end

  helper_method :current_user_session, :current_user, :current_organisation

  rescue_from CanCan::AccessDenied do |exception|
    status = current_user ? :forbidden : :unauthorized
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: {error: status}, status: status }
    end
  end

  def render_errors(model_or_errors, status, field = false)
    if model_or_errors.respond_to?(:errors)
      if field
        model_or_errors = model_or_errors.errors.messages
      else
        model_or_errors = model_or_errors.errors.full_messages
      end
    end

    if model_or_errors.is_a?(Array)
      model_or_errors = model_or_errors.join("
")
    end

    if field
      render json: model_or_errors, status: status
    else
      render text: model_or_errors, status: status
    end
  end

  # Update function for footage and movie
  # 
  def update_footage_or_movie(object, model, parameters, template = 'show')
    if object.update_attributes(parameters)
      @editing_enabled = true
      @similar_from_user = model.where("FALSE")
      @popular_in_same_category = model.where("FALSE")
      template = 'show' if template.nil?
      render template.to_sym, layout: false
    else
      render_errors(object, :unprocessable_entity)
    end
  end

  # Create project items
  # 
  # - equipemnts
  # - occupations
  # - specs
  # - stills
  # - tags
  # 
  def create_project_items(object, locals, options = {})
    options = options || {}
    options[:render] = options.has_key?(:render) ? options[:render] : object
    options[:layout] = options.has_key?(:layout) ? options[:layout] : false
    if object.save
      render options[:render], locals: locals, status: 201, layout: options[:layout]
    else
      render_errors object, :unprocessable_entity
    end
  end

  # Update project items
  # 
  # - specs
  # - equipments
  # 
  def update_project_items(object, locals, update_params, options = {})
    options = options || {}
    options[:render] = options.has_key?(:render) ? options[:render] : object
    if object.update_attributes(update_params)
      render options[:render], locals: locals
    else
      render_errors(object, :unprocessable_entity)
    end
  end

  private

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      flash[:notice] = t("user.login_first")
      redirect_to new_user_session_path
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = t("user.logout_first")
      redirect_to account_url
      return false
    end
  end

  def show_article_slider(val = false)
    @article_slider = val
  end

  def is_default_style?
    Frontend::APP_STYLE.empty?  
  end

  def current_organisation
    if session[:organisation]
      Organisation.find_by_token(session[:organisation])
    else
      nil
    end
  end

  # Used on feedback and report violation
  # 
  def respond_created_and_render_text
    respond_to do |format|
      format.html { render text: 'created', status: :created }
      format.js {}
    end
  end

  # Detect layout for mobile, tab and desktop
  # 
  def detect_variant
    if request.user_agent =~ /iPad|iPhone/
      request.variant = :mobile
    end
  end
end
