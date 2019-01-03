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

Frontend::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Rails 4
  config.eager_load = false

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  # config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  # config.action_dispatch.best_standards_support = :builtin

  config.active_record.migration_error = :page_load

  # Do not compress assets
  # config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :letter_opener

  config.paperclip_secret = ""

  # Change the following line to your "convert" directory
  Paperclip.options[:command_path] = "/usr/local/bin/"

  config.media_fileserver_options = {
    host: "3vaults", # internal 3vaults address ?
    port: "4567",
    auth: "",
    upload_url: "http://localhost:4568/cgi/uploader.cgi", # url for client
    public_url: "http://localhost:4568/media/", # url for client
    s3_url: "http://localhost:9000/3vaults/", # url for client
  }

  config.transcoder_polling_delay = 1
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
end
