class AvailabilityStatusMailer < ApplicationMailer
  default from: 'teamavailabilitystatus@gmail.com'

  def status_email
    @user = params[:user]
    @availability_statuses = params[:availability_statuses]
    mail(to: @user.email, subject: 'Daily Availability Status')
  end
end
