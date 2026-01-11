module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_request, only: [:login, :register]

      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: user_json(user)
          }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def register
        user = User.new(register_params)

        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: user_json(user)
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def refresh
        token = JsonWebToken.encode(user_id: current_user.id)
        render json: { token: token }
      end

      private

      def register_params
        params.permit(:email, :password, :password_confirmation, :username)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          username: user.username,
          level: user.level,
          total_points: user.total_points,
          current_streak: user.current_streak
        }
      end
    end
  end
end
