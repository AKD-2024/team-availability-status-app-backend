module Api
  module V1
    class AvailabilityStatusController < ApplicationController
      before_action :authenticate_user!

      def create
        status = AvailabilityStatus.find_or_initialize_by(user: current_user, date: Date.today)
        if status.update(status_params)
          render json: 
          { 
            message: 'Availability status updated successfully' 
          }, 
          status: :ok
        else
          render json: 
          { 
            errors: status.errors.full_messages 
          }, 
          status: :unprocessable_entity
        end
      end

      def index
        selected_date = date_param ? Date.parse(date_param) : Date.today

        statuses = AvailabilityStatus.where(date: selected_date).includes(:user)

        if statuses.empty?
          render json: 
          { 
            msg: 'No statuses found' 
          }, 
          status: :not_found
        else
          render json: statuses, include: { user: { only: :name } }, status: :ok
        end
      end

      private
      def date_param
        params.permit(:date)
      end

      def status_params
        params.require(:availability_status).permit(:status, :time, :location)
      end
    end
  end
end
