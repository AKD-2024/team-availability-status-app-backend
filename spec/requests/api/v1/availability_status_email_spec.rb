require 'swagger_helper'

RSpec.describe 'api/v1/availability_status_email', type: :request do
  path '/api/v1/send-status-email' do
    post 'Send availability status email' do
      tags 'AvailabilityStatusEmail'
      consumes 'application/json'
      description 'Send an email with the current availability status to the user'

      response '200', 'email sent' do
        let(:user) { User.create!(name: 'tester1', email: 'tester1@example.com', password: 'password123') }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
        end

        run_test!
      end

      response '401', 'unauthorized' do
        before do
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(nil)
        end

        run_test!
      end

      response '500', 'internal server error' do
        let(:user) { User.create!(name: 'tester1', email: 'tester1@example.com', password: 'password123') }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
          allow(AvailabilityStatusMailer).to receive(:status_email).and_raise(StandardError.new('Email service failed'))
        end

        run_test!
      end
    end
  end
end
