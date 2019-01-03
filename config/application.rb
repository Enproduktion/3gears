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

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'susy'

module Frontend

  APP_STYLE = 'ava'

  class << self
    def is_empty_style?
      self::APP_STYLE.empty?
    end

    def is_ava?
      self::APP_STYLE == 'ava'
    end

    def is_order_query_available?
      gem_available?('order_query')
    end

    def gem_available?(name)
       Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
       false
    rescue
       Gem.available?(name)
    end
  end

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'de'

    config.supported_locales = %w(en de)

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/commands)

    # Enable escaping HTML in JSON.
    # config.active_support.escape_html_entities_in_json = true

    config.assets.paths << Rails.root.join('app', 'assets', 'flash')
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    config.assets.precompile += %w( .svg .eot .woff .ttf .png)
    
    config.active_record.raise_in_transactional_callbacks = true

    Paperclip.options[:content_type_mappings] = {
        vtt: 'text/plain'
    }
  end
end
