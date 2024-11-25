class Customer < ApplicationRecord
  has_secure_password

  has_many :trips

  before_create :preprocess_create

  def preprocess_create
    self.invite_code = SecureRandom.hex(15)
    self.amount_invite = 0
  end

end
