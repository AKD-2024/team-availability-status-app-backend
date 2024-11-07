require 'swagger_helper'

RSpec.describe 'api/v1/availability_status', type: :request do
  path '/api/v1/availability_status' do
    post 'Create or update availability status' do
      tags 'AvailabilityStatus'
      consumes 'application/json'
      parameter name: :availability_status, in: :body, schema: {
        type: :object,
        properties: {
          availabilityStatus: { type: :string },
          time: { type: :string },
          location: { type: :string }
        },
        required: [ 'availabilityStatus' ]
      }

      response '200', 'availability status updated' do
        let(:user) { User.create!(name: 'tester1', email: 'tester@example.com', password: 'password123') }
        let(:availability_status) { { availabilityStatus: 'available', time: '09:00', location: 'office' } }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:user) { User.create!(name: 'tester1', email: 'tester@example.com', password: 'password123') }
        let(:availability_status) { { availabilityStatus: 'available', time: '09:00' } }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
        end

        run_test!
      end
    end
  end

  path '/api/v1/availability_status' do
    get 'List availability statuses for a specific date' do
      tags 'AvailabilityStatus'
      produces 'application/json'
      parameter name: :date, in: :query, type: :string, example: '2024-11-06', description: 'Date in YYYY-MM-DD format'

      response '200', 'statuses found' do
        let(:user) { User.create!(name: 'tester1', email: 'tester1@example.com', password: 'password123') }
        let(:date) { Date.today }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
          AvailabilityStatus.create!(user: user, date: date, availabilityStatus: 'available', time: '09:30', location: 'office')
        end

        run_test!
      end

      response '404', 'no statuses found' do
        let(:user) { User.create!(name: 'tester1', email: 'tester1@example.com', password: 'password123') }
        let(:date) { '2024-11-07' }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
        end

        run_test!
      end

      response '500', 'server error' do
        let(:user) { User.create!(name: 'tester1', email: 'tester1@example.com', password: 'password123') }
        let(:date) { 'invalid-date' }

        before do
          token = generate_token(user)
          allow(request.cookies).to receive(:[]).with(:access_token).and_return(token)
        end

        run_test!
      end
    end
  end
end
