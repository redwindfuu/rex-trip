# == Schema Information
#
# Table name: blacklisted_tokens
#
#  id         :bigint           not null, primary key
#  uuid       :uuid
#  type       :string
#  revoked_at :datetime
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BlacklistedToken < ApplicationRecord
  self.inheritance_column = :role
end
