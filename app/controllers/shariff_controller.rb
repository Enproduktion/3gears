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

class ShariffController < ApplicationController

  def shariff
    if params[:url].nil? or params[:url].empty?
      escaped_url = URI.escape("http://www.example.com/")
    else
      escaped_url = URI.escape(params[:url])
    end
    result = {
        facebook: facebook_share(escaped_url),
        twitter:  twitter_share(escaped_url) 
      }
    render json: result.to_json
  end

  private

  def facebook_share(url)
    request_url = "http://graph.facebook.com/?id=#{url}"
    data = http_request(request_url)
    (data['shares'].nil?) ? 0 : data['shares']
  rescue
    0
  end

  def twitter_share(url)
    request_url = "http://urls.api.twitter.com/1/urls/count.json?url=#{url}"
    data = http_request(request_url)
    data['count']
  rescue
    0
  end

  def http_request(url)
    data = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(data)
  end
end
