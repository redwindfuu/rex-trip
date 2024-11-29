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
require "test_helper"

class BlacklistedTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
