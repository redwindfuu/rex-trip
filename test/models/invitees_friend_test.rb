# == Schema Information
#
# Table name: invitees_friends
#
#  id         :bigint           not null, primary key
#  from_type  :string           not null
#  from_id    :bigint           not null
#  to_type    :string           not null
#  to_id      :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class InviteesFriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
