# == Schema Information
#
# Table name: refresh_tokens
#
#  id            :bigint           not null, primary key
#  crypted_token :string
#  uuid          :uuid
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class RefreshToken < ApplicationRecord
  before_create :set_crypted_token
  attr_accessor :token
  self.inheritance_column = :role

  def self.find_by_token(token)
    crypted_token = Digest::SHA256.hexdigest token
    data = RefreshToken.find_by(crypted_token: crypted_token)
    data
  end

  def set_crypted_token
    self.token = SecureRandom.hex
    self.crypted_token = Digest::SHA256.hexdigest(token)
  end

  def self.find_by_token_and_type(token, type)
    crypted_token = Digest::SHA256.hexdigest token
    RefreshToken.find_by(crypted_token: crypted_token, type: type)
  end
end
