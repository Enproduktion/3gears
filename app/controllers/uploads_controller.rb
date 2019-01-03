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

class UploadsController < ApplicationController
  load_and_authorize_resource :medium, parent: false

  def update
    filename = params[:medium][:original_filename]
    filesize = params[:medium][:filesize].to_i

    if @medium.fileserver_handle
      if not filename.blank?
        if @medium.original_filename != filename
          render_errors("filename mismatch", :unprocessable_entity)
          return
        end
        if @medium.filesize != filesize
          render_errors("filesize mismatch", :unprocessable_entity)
          return
        end
      end
    else
      begin
        @medium.request_upload_ticket(filename, filesize)
      rescue RemoteRequest::RequestError => error
        logger.error("request_upload_ticket: #{error.message}. Is 3vaults running?")
        render_errors("file server error", :service_unavailable)
        return
      end
    end

    if params[:medium][:ready] == "true"
      @medium.upload_completed
    end

    render json: @medium.upload_url.to_json
  end
end
