require_relative 'boot'

require 'rails/all'

require 'active_storage/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module Omaps
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Session::CookieStore, {:key=>"_omaps_session", :cookie_only=>true}

    
    config.load_defaults 5.2

    config.i18n.default_locale = :de

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    
  end
end
