require 'bigdecimal'

class Driver < ApplicationRecord
  has_secure_password
  enum status: { not_yet: 0, pending: 1, approved: 2, rejected: 3 }
  belongs_to :kyc_by, class_name: Admin.name, optional: true

  before_create :preprocess_create

  def preprocess_create
    self.invite_code = SecureRandom.hex(15)
    self.rating_avg = 3.0
    self.balance = 0
    self.is_available= false
    self.amount_invite = 0
  end
end
