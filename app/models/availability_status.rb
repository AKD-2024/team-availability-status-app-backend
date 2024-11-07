class AvailabilityStatus < ApplicationRecord
  belongs_to :user

  enum status: { available: 'available', leave: 'leave' }
  enum location: { home: 'home', office: 'office' }

  validates :user, presence: true
  validates :status, presence: true
  validates :time, presence: true, if: -> { status == 'available' }
  validates :location, presence: true, if: -> { status == 'available' }

  attribute :date, :date, default: -> { Date.today }
end
