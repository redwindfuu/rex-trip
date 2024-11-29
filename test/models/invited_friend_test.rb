# == Schema Information
#
# Table name: invited_friends
#
#  id          :bigint           not null, primary key
#  to_uuid     :uuid             not null
#  from_uuid   :uuid             not null
#  invite_code :string           not null
#  invite_type :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class InvitedFriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
