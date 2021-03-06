require_relative 'boot'

require 'rails/all'

require 'active_storage/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Omaps
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.i18n.default_locale = :de

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips
    
    config.active_job.queue_adapter = :delayed_job

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
