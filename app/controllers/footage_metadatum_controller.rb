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

class FootageMetadatumController < ApplicationController
  load_and_authorize_resource

  def update
    if @footage_metadatum.update(permitted_params)
      render json: @footage
    else
      render json: { errors: @footage_metadatum.errors.full_messages }
    end
  end

  def file_upload
    metadata = JSON.parse(file_upload_params[:transcript_file].read)

    @footage_metadatum.fill_from_jsonld(metadata)

    if @footage_metadatum.save!
      success_flash = t 'footage.update_success'
    else
      alert_flash = @footage_metadatum.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.html {
        flash[:succes] = success_flash if success_flash != nil
        flash[:alert] = alert_flash if alert_flash != nil
        redirect_to @footage_metadatum.footage
      }
      format.json {render json: @footage_metadatum}
    end

  end


  private
  def permitted_params
    params.require(:footage_metadatum).permit(:country,
                                                :cast,
                                                :original_format,
                                                :original_length,
                                                :original_language,
                                                :year_of_reference,
                                                :genre,
                                                :citations,
                                                :source)
  end

  def file_upload_params
    params.require(:footage_metadatum).permit(:transcript_file)
  end
end
