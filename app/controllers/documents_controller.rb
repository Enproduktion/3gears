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

class DocumentsController < ApplicationController
  load_and_authorize_resource :movie_or_idea
  load_and_authorize_resource :document, through: :movie_or_idea, except: [:update]
  load_and_authorize_resource :document, only: [:update]


  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Create document
  # this will load 'create_params' private method
  # for passing protected parameters
  #
  def create
    if @document.save()
      respond_to do |format|
        format.html {
          flash[:success] = t 'document.create_success'
          redirect_to @document.movie_or_idea
        }
        format.json {render json: @document, status: :created}
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = @document.errors.full_messages.to_sentence
          redirect_to @document.movie_or_idea
        }
        format.json {render json: @document, status: :unprocessable_entity}
      end
    end
  end

  def update
    if @document.update_attributes(update_params)
      respond_to do |format|
        format.html {
          flash[:success] = t 'document.create_success'
          redirect_to @document.movie_or_idea
        }
        format.json {render json: @document, status: :ok}
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = @document.errors.full_messages.to_sentence
          redirect_to @document.movie_or_idea
        }
        format.json {render json: @document, status: :unprocessable_entity}
      end
    end
  end

  # delete document
  # from movie, idea or footage
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    head :ok
  end

  def download
    send_file @document.document.path, filename: @document.document_file_name
  end

  private
  def create_params
    params.require(:document).permit(:document)
  end

  def update_params
    params.require(:document).permit(:document_file_name)
  end
end
