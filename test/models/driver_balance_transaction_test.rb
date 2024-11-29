# == Schema Information
#
# Table name: driver_balance_transactions
#
#  id                 :bigint           not null, primary key
#  uuid               :uuid             not null
#  driver_id          :bigint           not null
#  amount             :decimal(10, 2)
#  balance_after      :decimal(10, 2)
#  transaction_type   :integer
#  transaction_status :integer
#  approved_by_id     :bigint
#  approved_at        :datetime
#  requested_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "test_helper"

class DriverBalanceTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
