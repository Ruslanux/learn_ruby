# frozen_string_literal: true

if ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.environment = ENV.fetch("SENTRY_ENVIRONMENT", Rails.env)
    config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

    # Set traces_sample_rate to capture a percentage of transactions for tracing
    # We recommend adjusting this value in production
    config.traces_sample_rate = Rails.env.production? ? 0.1 : 1.0

    # Set profiles_sample_rate to profile a percentage of sampled transactions
    # We recommend adjusting this value in production
    config.profiles_sample_rate = Rails.env.production? ? 0.1 : 1.0

    # Don't send sensitive data
    config.send_default_pii = false

    # Filter out sensitive parameters
    config.before_send = lambda do |event, hint|
      # Filter sensitive data from the event
      event
    end

    # Ignore common bot/scanner errors
    config.excluded_exceptions += [
      "ActionController::RoutingError",
      "ActionController::InvalidAuthenticityToken"
    ]
  end
end
