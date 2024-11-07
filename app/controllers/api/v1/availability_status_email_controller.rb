module Api
  module V1
    class AvailabilityStatusEmailController < ApplicationController
      before_action :authenticate_user!

      def send_email

        date = date_param || Date.today.to_s

        availability_statuses = AvailabilityStatus.where(date: Date.parse(date)).includes(:user)

        if availability_statuses.empty?
          render json: 
          { 
            message: "No availability statuses found for #{Date.parse(date)}" 
          }, 
          status: :not_found
          return
        end

        begin
          AvailabilityStatusMailer.with(user: current_user,  availability_statuses: availability_statuses).status_email.deliver_now!
          render json: 
          { 
            message: 'Availability status email sent' 
          }, 
          status: :ok
        rescue StandardError => e
          Rails.logger.error "Failed to send email: #{e.message}"
          render json: 
          { 
            message: 'Failed to send availability status email' 
          }, 
          status: :internal_server_error
        end
      end

      private
      def date_param
        params.permit(:date)
      end
    end
  end
end
