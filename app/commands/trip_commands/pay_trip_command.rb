# frozen_string_literal: true

module TripCommand
  class PayTripCommand
    prepend SimpleCommand

    def initialize(trip_id , amount)
      @trip_id = trip_id
      @amount = amount
    end

    def call
      raise Errors::BadRequest unless @trip_id
      Trip.transaction do
        trip = Trip.find_by(id: @trip_id)
        raise Errors::NotFound, "Trip not found" unless trip
        raise Errors::BadRequest, "Trip is not finished yet" unless trip.FINISHED? || trip.CANCELED?
        payment = Payment.create!(trip_id: @trip_id, amount: @amount)

      end

    end

  end
end
