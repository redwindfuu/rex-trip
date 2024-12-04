# frozen_string_literal: true

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
class ArrivalSerializer < ActiveModel::Serializer
  attributes :id, :end_time_est, :order_place, :name
  has_one :place, serializer: PlaceSerializer

  def place
    object.place
  end
end
