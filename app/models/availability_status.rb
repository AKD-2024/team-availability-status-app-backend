class AvailabilityStatus < ApplicationRecord
  belongs_to :user

  enum availabilityStatus: { available: 'available', leave: 'leave' }
  enum location: { home: 'home', office: 'office' }

  validates :user, presence: true
  validates :availabilityStatus, presence: true
  validates :time, presence: true, if: -> { availabilityStatus == 'available' }
  validates :location, presence: true, if: -> { availabilityStatus == 'available' }

  attribute :date, :date, default: -> { Date.today }
end
