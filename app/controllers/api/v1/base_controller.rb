module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::MimeResponds

      before_action :authenticate_request

      attr_reader :current_user

      private

      def authenticate_request
        header = request.headers["Authorization"]
        token = header.split(" ").last if header

        begin
          decoded = JsonWebToken.decode(token)
          @current_user = User.find(decoded[:user_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "User not found" }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { error: e.message }, status: :unauthorized
        end
      end

      def authenticate_request!
        authenticate_request unless @current_user
      end

      def skip_authentication
        # Allow unauthenticated access
      end
    end
  end
end
