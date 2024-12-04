# == Schema Information
#
# Table name: payments
#
#  id         :bigint           not null, primary key
#  uuid       :uuid             not null
#  trip_id    :bigint           not null
#  amount     :decimal(10, 2)
#  method     :integer          default("cash")
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
