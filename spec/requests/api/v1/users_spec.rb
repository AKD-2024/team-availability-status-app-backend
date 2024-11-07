require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/register' do
    post 'User Registration' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          role: { type: :string }
        },
        required: [ 'name', 'email', 'password' ]
      }

      response '201', 'user registered' do
        let(:user) { { name: 'user', email: 'user@example.com', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: '', email: 'john@example.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/login' do
    post 'User Login' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'user logged in' do
        let(:user) { { email: 'user@example.com', password: 'password' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:credentials) { { email: 'user@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/logout' do
    post 'User Logout' do
      tags 'Users'
      produces 'application/json'

      response '200', 'logout successful' do
        before do
          user = User.create(name: 'Tester', email: 'tester@example.com', password: 'password123', role: 'admin')
          token = JWT.encode({ user_id: user.id, email: user.email }, ENV['secret_key_base'], 'HS256')
          cookies[:access_token] = token
        end

        run_test!
      end

      response '401', 'unauthorized - no token present' do
        before { cookies.delete(:access_token) }
        run_test!
      end
    end
  end
end
