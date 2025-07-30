require File.expand_path('../boot', __FILE__)

require 'rails/all'
require File.expand_path('../../app/utilities/asset_host', __FILE__)
require File.expand_path('../../app/utilities/boolean_environment_variable', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# rubocop:disable Style/IfUnlessModifier
module Killswitch
  class Application < Rails::Application
    # Version
    VERSION = '2.0.0-pre01'.freeze

    config.load_defaults 7.2

    # English!
    config.i18n.default_locale = :en

    # Do not wrap erroenous form fields with a div
    # rubocop:disable Rails/OutputSafety
    config.action_view.field_error_proc = lambda { |html_tag, _| html_tag.to_s.html_safe }
    # rubocop:enable Rails/OutputSafety

    # Custom exceptions
    config.action_dispatch.rescue_responses['BehaviorDispatcher::MissingParameter'] = :bad_request
    config.action_dispatch.rescue_responses['CanCan::AccessDenied'] = :forbidden

    # Force SSL on everything except '/killswitch' endpoint
    if Rails.application.config_for(:settings)[:force_ssl]
      config.middleware.use Rack::SSL, exclude: lambda { |env| Rack::Request.new(env).path == '/killswitch' }
    end

    # Rack::Cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i(get)
      end
    end

    # Rack::Accept
    config.middleware.use Rack::Accept

    # Canonical host
    if Rails.application.config_for(:settings)[:domain]
      config.middleware.use Rack::CanonicalHost, Rails.application.config_for(:settings)[:domain]
    end

    # Basic Auth
    if Rails.application.config_for(:settings)[:auth_username] && Rails.application.config_for(:settings)[:auth_password]
      config.middleware.use Rack::Auth::Basic, 'Protected Area' do |username, password|
        username == Rails.application.config_for(:settings)[:auth_username] && password == Rails.application.config_for(:settings)[:auth_password]
      end
    end

    # Mailers
    config.action_mailer.default_url_options = { host: Rails.application.config_for(:settings)[:domain], port: Rails.application.config_for(:settings)[:port] }
    config.action_mailer.asset_host = AssetHost.new(Rails.application.config_for(:settings)).to_s

    # SMTP server
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: Rails.application.config_for(:settings)[:smtp_address],
      port: Rails.application.config_for(:settings)[:smtp_port],
      user_name: Rails.application.config_for(:settings)[:smtp_username],
      password: Rails.application.config_for(:settings)[:smtp_password]
    }
  end
end
# rubocop:enable Style/IfUnlessModifier
