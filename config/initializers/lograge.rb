# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  # Keep original Rails logger for development
  config.lograge.keep_original_rails_log = Rails.env.development?

  # Add custom data to log output
  config.lograge.custom_options = lambda do |event|
    options = {
      time: Time.current.iso8601,
      request_id: event.payload[:request_id],
      host: event.payload[:host]
    }

    # Add user_id if available
    if event.payload[:user_id].present?
      options[:user_id] = event.payload[:user_id]
    end

    # Add exception info if present
    if event.payload[:exception].present?
      options[:exception] = event.payload[:exception].first
      options[:exception_message] = event.payload[:exception].last
    end

    options
  end

  # Custom payload additions
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.respond_to?(:current_user) && controller.current_user&.id,
      request_id: controller.request.request_id
    }
  end

  # Ignore certain actions from logs
  config.lograge.ignore_actions = [
    "Rails::HealthController#show"
  ]
end
