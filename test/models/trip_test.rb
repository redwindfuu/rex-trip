# == Schema Information
#
# Table name: trips
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  fight_no        :string
#  driver_id       :bigint
#  customer_id     :bigint
#  depart_place_id :bigint
#  booking_time    :datetime
#  seat            :integer
#  start_time_est  :datetime
#  start_time_real :datetime
#  trip_status     :integer          default("WAITING_DRIVER_APPROVE")
#  rating          :integer
#  total_price     :decimal(, )
#  est_price       :decimal(, )
#  fee             :decimal(, )
#  fee_rate        :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  end_time_real   :datetime
#
require "test_helper"

class TripTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
