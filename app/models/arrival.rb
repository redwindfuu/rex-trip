# == Schema Information
#
# Table name: arrivals
#
#  id            :bigint           not null, primary key
#  name          :string
#  place_id      :bigint
#  trip_id       :bigint
#  order_place   :integer
#  end_time_est  :datetime
#  end_time_real :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Arrival < ApplicationRecord
  belongs_to :trip
  belongs_to :place
end
