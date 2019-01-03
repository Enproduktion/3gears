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

FROM ruby:2.3

MAINTAINER Enproduktion <n@produktion.io>

WORKDIR /sphinx

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    libexpat1 \
    libmysqlclient18 \
    libodbc1 \
    libpq5 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget http://sphinxsearch.com/files/sphinxsearch_2.2.11-release-1~jessie_amd64.deb \
 && dpkg -i sphinxsearch_2.2.11-release-1~jessie_amd64.deb


# Prerequisites

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    libmysqlclient-dev \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm3 \
    libgdbm-dev \
    python-mysqldb \
    zlib1g-dev \
    curl \
    python-pip \
    python-virtualenv \
    python-dev \
    graphviz \
    libmysqlclient-dev \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    imagemagick \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm3 \
    libgdbm-dev \
    python-mysqldb \
    libodbc1 \
    unixodbc \
    libpq5 \
    vim \
    libc6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# 3gears-articles

WORKDIR /gems/3gears-articles

COPY gems/3gears-articles /gems/3gears-articles

RUN cd /gems/3gears-articles \
 && gem build 3gears-articles.gemspec \
 && gem install 3gears-articles-0.1.0.gem


# 3gears
# !! No change in locales !!

WORKDIR /3gears

COPY . /3gears

RUN bundle install

