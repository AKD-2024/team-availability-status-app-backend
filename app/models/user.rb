class User < ApplicationRecord
  has_secure_password

  enum role: { member: 'member', admin: 'admin' }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_initialize :set_default_role, if: :new_record?

  private
  def set_default_role
    self.role ||= 'member'
  end
end
