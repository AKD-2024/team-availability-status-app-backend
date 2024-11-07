class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authenticate_user!

  private

  def authenticate_user!
    token = cookies[:access_token]

    begin
      decoded_token = JWT.decode(token, ENV['secret_key_base'], true, { algorithm: 'HS256' })
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: 'Token has expired' }, status: :unauthorized
    rescue JWT::VerificationError
      render json: { error: 'Token verification failed' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
