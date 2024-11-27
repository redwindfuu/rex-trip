# frozen_string_literal: true

class TripSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :fight_no, :booking_time, :seat, :trip_status, :rating, :total_price
  has_one :driver, serializer: DriverSerializer, if: -> { object.driver_id.present? }
  has_one :customer, serializer: CustomerSerializer
  has_one :depart_place , serializer: PlaceSerializer
  has_many :arrivals, serializer: ArrivalSerializer



end
