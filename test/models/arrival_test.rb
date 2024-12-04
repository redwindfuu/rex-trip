# == Schema Information
#
# Table name: arrivals
#
#  id           :bigint           not null, primary key
#  name         :string
#  place_id     :bigint
#  trip_id      :bigint
#  order_place  :integer
#  end_time_est :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class ArrivalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
