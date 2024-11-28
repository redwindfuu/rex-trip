# frozen_string_literal: true

module TripCommands
  class ApproveTripCommand

    prepend SimpleCommand

    attr_accessor :driver_id, :trip_id

    def initialize(driver_id, trip_id)
      @driver_id = driver_id
      @trip_id = trip_id
    end

    def call
      cmd = TripValidator::ApproveTripValidator.call(params: {
        driver_id: driver_id.to_i,
        trip_id: trip_id.to_i
      })
      if cmd.failure?
        errors.add(:error, cmd.errors)
        return nil
      end

      driver = Driver.lock.find_by(id: driver_id)
      trip = Trip.lock.find_by(id: @trip_id)
      if driver.nil? || !driver.is_available?
        errors.add(:error, "Driver is not available")
        return nil
      end

      if trip.nil? || !trip.WAITING_DRIVER_APPROVE?
        errors.add(:error, "Trip not found")
        return nil
      end
      # save trip
      trip.driver_id = driver_id
      trip.trip_status = Trip.trip_statuses[:WAITING_ARRIVE]
      trip.save
      driver.update!(is_available: false)
    end

  end
end
