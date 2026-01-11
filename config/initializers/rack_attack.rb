class Rack::Attack
  # Configure cache store (use Rails cache)
  Rack::Attack.cache.store = Rails.cache

  # Throttle API requests by IP (100 requests per minute)
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Throttle code execution endpoints (10 requests per minute per user)
  throttle("api/code_execution", limit: 10, period: 1.minute) do |req|
    if req.path.match?(%r{/api/v1/exercises/\d+/(run|submit)})
      # Get user from JWT token
      token = req.get_header("HTTP_AUTHORIZATION")&.split(" ")&.last
      if token
        begin
          decoded = JsonWebToken.decode(token)
          decoded[:user_id]
        rescue
          req.ip
        end
      else
        req.ip
      end
    end
  end

  # Throttle authentication attempts (5 per minute per IP)
  throttle("api/auth", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  # Throttle registration (3 per hour per IP)
  throttle("api/registration", limit: 3, period: 1.hour) do |req|
    if req.path == "/api/v1/auth/register" && req.post?
      req.ip
    end
  end

  # Block suspicious requests
  blocklist("block-bad-requests") do |req|
    # Block requests with obviously malicious patterns
    req.path.include?("..") || req.path.include?("%00")
  end

  # Custom throttle response
  self.throttled_responder = lambda do |request|
    retry_after = (request.env["rack.attack.match_data"] || {})[:period]

    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [{
        error: "Rate limit exceeded",
        retry_after: retry_after
      }.to_json]
    ]
  end
end

# Log blocked and throttled requests in development
if Rails.env.development?
  ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_name, _start, _finish, _id, payload|
    Rails.logger.warn "[Rack::Attack] Throttled #{payload[:request].ip} - #{payload[:request].path}"
  end

  ActiveSupport::Notifications.subscribe("blocklist.rack_attack") do |_name, _start, _finish, _id, payload|
    Rails.logger.warn "[Rack::Attack] Blocked #{payload[:request].ip} - #{payload[:request].path}"
  end
end
