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

# In the apache config the environment variable GEM_HOME is set to
# match the distribution.

FROM ruby:2.3
MAINTAINER Enproduktion GmbH <docker@produktion.io>

EXPOSE 4568
VOLUME /data

RUN apt-get update && apt-get -y install apache2

COPY docker/receiver/apache2.conf /etc/apache2/apache2.conf

WORKDIR /3vaults

COPY src/Gemfile /3vaults/Gemfile
COPY src/Gemfile.lock /3vaults/Gemfile.lock
RUN bundle install

COPY src /3vaults

CMD rm -f /var/run/apache2.pid && apache2 -DFOREGROUND
