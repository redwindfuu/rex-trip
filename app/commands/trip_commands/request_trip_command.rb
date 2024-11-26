# frozen_string_literal: true

module TripCommands
  class RequestTripCommand
    prepend SimpleCommand

    def initialize(customer_id, trip_params)
      @customer_id = customer_id
      @trip_params = trip_params
    end

    def call
      raise Errors::BadRequest unless @customer_id && @trip_params

      trip = Trip.new(@trip_params)
      trip.customer_id = @customer_id
      if trip.save
        trip
      else
        errors.add(:base, trip.errors.full_messages)
      end
    end
  end
end
