class Admin < ApplicationRecord
  include RexyAdmin
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :drivers, foreign_key: :kyc_by_id
end
