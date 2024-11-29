# == Schema Information
#
# Table name: admins
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  username        :string
#  password_digest :string
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Admin < ApplicationRecord
  include RexyAdmin
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :drivers, foreign_key: :kyc_by_id
end
