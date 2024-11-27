# frozen_string_literal: true

module TripCommand
  class ApproveTripCommand

    prepend SimpleCommand

    def initialize(driver_id, trip_id)
      @trip_id = trip_id
    end

    def call
      raise Errors::BadRequest unless @trip_id && driver_id
      # lock here
      Trip.transaction do
        driver = Driver.find_by(id: driver_id)
        raise Errors::NotFound, "Driver is already in a trip" if driver.nil? || driver.is_available?
        trip = Trip.lock.find_by(id: @trip_id)
        raise Errors::NotFound, "Trip not found" unless trip
        raise Errors::BadRequest, "Trip is not waiting for driver approve" unless trip.WAITING_DRIVER_APPROVE?
        trip.driver_id = driver_id
        trip.status = Trip.trip_statuses[:WAITING_ARRIVE]
        trip.save!
      end
    end

  end
end
