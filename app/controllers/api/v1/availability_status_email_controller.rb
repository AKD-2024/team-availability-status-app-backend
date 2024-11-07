module Api
  module V1
    class AvailabilityStatusEmailController < ApplicationController
      before_action :authenticate_user!

      def send_email
        date_param = params[:date] || Date.today.to_s
        selected_date = Date.parse(date_param)

        availability_statuses = AvailabilityStatus.where(date: selected_date).includes(:user)

        if availability_statuses.empty?
          render json: { message: "No availability statuses found for #{selected_date}" }, status: :not_found
          return
        end

        begin
          AvailabilityStatusMailer.with(user: current_user,  availability_statuses: availability_statuses).status_email.deliver_now!
          render json: { message: 'Availability status email sent' }, status: :ok
        rescue StandardError => e
          Rails.logger.error "Failed to send email: #{e.message}"
          render json: { message: 'Failed to send availability status email' }, status: :internal_server_error
        end
      end
    end
  end
end
