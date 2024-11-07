module AuthHelper
  def generate_token(user)
    payload = { user_id: user.id, email: user.email }
    JWT.encode(payload, ENV["secret_key_base"], "HS256")
  end
end
