# frozen_string_literal: true

class ArrivalSerializer < ActiveModel::Serializer
  attributes :id, :end_time_est, :order_place, :name
  has_one :place, serializer: PlaceSerializer
end
