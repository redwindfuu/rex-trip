# == Schema Information
#
# Table name: place_expenses
#
#  id              :bigint           not null, primary key
#  from_place_id   :bigint           not null
#  to_place_id     :bigint           not null
#  price           :decimal(10, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  time_of_expense :integer
#
require "test_helper"

class PlaceExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
