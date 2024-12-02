# == Schema Information
#
# Table name: customers
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  full_name       :string
#  email           :string
#  phone           :string
#  avatar_link     :string
#  username        :string
#  password_digest :string
#  amount_invite   :integer
#  invite_code     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Customer < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :trips

  belongs_to :invitees, polymorphic: true, optional: true

  has_many :driver, as: :invitees
  
  before_create :preprocess_create

  def preprocess_create
    self.invite_code = SecureRandom.hex(15)
    self.amount_invite = 0
  end
end
