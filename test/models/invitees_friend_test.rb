# == Schema Information
#
# Table name: invitees_friends
#
#  id              :bigint           not null, primary key
#  inviter_type    :string           not null
#  inviter_id      :bigint           not null
#  inviteable_type :string           not null
#  inviteable_id   :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class InviteesFriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
