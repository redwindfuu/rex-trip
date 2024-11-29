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
require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
