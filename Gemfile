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

source 'https://rubygems.org'

ruby '2.3.4'

gem 'foreman'
gem 'rails', '~> 4.2.7.1'

# Database
gem 'mysql2', '~> 0.3.17'
gem 'acts_as_list'
gem 'thinking-sphinx', '~> 3.2.0'
gem 'default_value_for', '~> 3.0.0'
gem "active_model_serializers", "~> 0.8.3"

# Assets
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'sass-rails', '~> 5.0.1'
gem 'compass-rails', '~> 2.0.4'
gem 'breakpoint'
gem 'susy'
gem 'coffee-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'angularjs-rails'
gem 'react-rails'
gem 'sprockets-coffee-react'
gem 'chosen-rails'
gem 'font-awesome-sass'
gem 'select2-rails', '~> 4.0.0', github: '3gears/select2-rails'
gem 'videojs_rails'

# Authentication & Authorization
gem 'authlogic', '~> 3.4.2'
gem 'scrypt'
gem 'cancancan'

# Uploads
gem 'paperclip'
gem 'delayed_paperclip'
gem 'remotipart', '~> 1.2.1'

# Views
gem 'rdiscount'
gem 'haml'
gem 'jbuilder'
gem 'iso8601'
gem 'dynamic_form'
gem 'kaminari'
gem 'country_select'
gem 'jbuilder'
# Static pages

gem 'high_voltage', '~> 3.0.0'

# Theme
gem 'themes_on_rails'

# Share
gem 'shariff_backend', github: '3gears/shariff-backend-ruby'

# Language
gem 'i18n-js'
gem 'rails-i18n'
gem 'http_accept_language'
gem 'countries'

gem 'resque'
gem "therubyracer"

# Use unicorn as the web server
gem 'puma'

# add these gems to help with the transition
gem 'activesupport-json_encoder'


group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', '~> 2.8'
  gem 'cucumber-rails', :require => false
  gem 'cucumber_statistics'
  gem 'viewcumber', github: '3gears/testinspector'
  gem 'database_cleaner'
  gem 'email_spec'
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
  gem "codeclimate-test-reporter", require: nil
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'faker'
  gem 'selenium-webdriver', '~> 2.45.0'
end

group :development do
  gem "rails-erd"
  gem 'capistrano'
  gem "letter_opener"

  gem 'pry-rails'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '0.2.0'
  gem 'lol_dba'
  gem 'fake_sqs'
  gem 'bullet'
  # gem 'rack-mini-profiler'
end

group :production do
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
