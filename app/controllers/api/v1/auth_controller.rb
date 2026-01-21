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
            user: UserSerializer.serialize(user, variant: :auth)
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
            user: UserSerializer.serialize(user, variant: :auth)
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
    end
  end
end
