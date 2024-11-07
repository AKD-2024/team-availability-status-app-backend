module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::Cookies
      before_action :authenticate_user!, only: [ :logout ]

      def register
        user = User.new(user_params)
        if user.save
          render json: { message: 'User registered successfully', user: user.as_json(except: [ :password_digest ]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = generate_access_token(user)

          cookies[:access_token] = {
            value: token,
            httponly: true,
            expires: 24.hours.from_now
          }

          render json: { message: 'Login successful', user: user.as_json(except: [ :password_digest ]),  access_token: token }, status: :ok
        else
          render json: { message: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def logout
        cookies.delete(:access_token, path: '/')
        render json: { message: 'Logout successful' }, status: :ok
      end

      private
      def user_params
        params.permit(:name, :email, :password, :role)
      end

      def generate_access_token(user)
        payload = { user_id: user.id, email: user.email }
        JWT.encode(payload, ENV['secret_key_base'], 'HS256')
      end
    end
  end
end
