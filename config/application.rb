require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require "action_controller/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
#require "active_model/validations"
require 'active_model'
#require "active_model/conversion"
#require "active_model/conversion"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module TwitterSocketStreaming
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.version = '1.0'

    # Load up environment specific config from config/environment.yml into ENV
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'environment.yml')
      YAML.load(File.open(env_file))[Rails.env.to_s].each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

  end
end
