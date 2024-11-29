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
require "test_helper"

class RefreshTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
