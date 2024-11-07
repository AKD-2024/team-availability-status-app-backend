module Api
  module V1
    class AvailabilityStatusController < ApplicationController
      before_action :authenticate_user!

      def create
        status = AvailabilityStatus.find_or_initialize_by(user: current_user, date: Date.today)
        if status.update(status_params)
          render json: { message: 'Availability status updated successfully' }, status: :ok
        else
          render json: { errors: status.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
          begin
            date_param = params[:date]
            selected_date = date_param ? Date.parse(date_param) : Date.today

            statuses = AvailabilityStatus.where(date: selected_date).includes(:user)

            if statuses.empty?
              render json: { msg: 'No statuses found' }, status: :not_found
            else
              render json: statuses, include: { user: { only: :name } }, status: :ok
            end
          rescue => e
            Rails.logger.error e.message
            render json: { msg: 'Server error' }, status: :internal_server_error
          end
      end

      private
      def status_params
        params.require(:availability_status).permit(:availabilityStatus, :time, :location)
      end
    end
  end
end
