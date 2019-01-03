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

class TagsController < ApplicationController
  include HasPolymorphicParent
  before_filter { @taggable = find_polymorphic_parent }
  authorize_resource :taggable, except: :suggest
  load_and_authorize_resource through: :taggable, except: :suggest

  # manual authorization
  skip_authorize_resource only: :destroy

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Create tag
  # @tag is created from load_and_authorize_resource :tag, through: :taggable, except: :suggest
  # this will load 'create_params' private method
  # for passing protected parameters
  # 
  def create
    create_project_items(@tag, {tag: @tag, taggable: @taggable, editable: true }, options)
  end

  # Delete tag from taggable
  # 
  def destroy
    authorize! :update, @taggable
    @taggable.tags.delete(@tag)
    @taggable.save
    head :ok
  end

  def suggest
    suggestions = Tag.autocomplete_suggestions(params[:term], 5).map &:name
    render json: suggestions.to_json
  end

  private
  # pass protected parameters for create method
  # 
  def create_params
    params.require(:tag).permit(:name)
  end

  def options_3gears
    case params[:parent_class]
    when "Footage", "MovieOrIdea", "Article"
      options = {render: '_mobile_edit_tag'}
    else
      options = {}
    end
    options
  end
end
