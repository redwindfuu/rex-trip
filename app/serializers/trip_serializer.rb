# frozen_string_literal: true

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
#
class TripSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :fight_no, :booking_time, :seat, :trip_status, :rating, :total_price
  has_one :driver, serializer: DriverSerializer, if: -> { object.driver_id.present? }
  has_one :customer, serializer: CustomerSerializer
  has_one :depart_place, serializer: PlaceSerializer
  has_many :arrivals, serializer: ArrivalSerializer

  def total_price
    object.total_price.to_f
  end

  def driver
    object.driver
  end

  def customer
    object.customer
  end

  def depart_place
    object.depart_place
  end

  def arrivals
    object.arrivals
  end
end
