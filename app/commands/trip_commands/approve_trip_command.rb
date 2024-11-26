# frozen_string_literal: true

module TripCommand
  class ApproveTripCommand

    prepend SimpleCommand

    def initialize(driver_id, trip_id)
      @trip_id = trip_id
    end

    def call
      raise Errors::BadRequest unless @trip_id
      # lock here
      trip = Trip.find(@trip_id)

      trip.approved = true
      if trip.save
        trip
      else
        errors.add(:base, trip.errors.full_messages)
      end


    end

  end
end
