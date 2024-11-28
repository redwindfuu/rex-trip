# frozen_string_literal: true

module TripCommands
  class RateTripCommand
    prepend SimpleCommand

    attr_accessor :trip_id, :rating,

    def initialize(trip_id, rating)
      @trip_id = trip_id
      @rating = rating
    end

    def call
      cmd = TripValidator::RateTripValidator.call(params: {
        trip_id: trip_id.to_i,
        rating: rating
      })

      if cmd.failure?
        errors.add(:error, cmd.errors)
        return
      end

      trip = Trip.find_by(id: trip_id)

      if trip.nil? || trip.CANCELED?
        errors.add(:error, "Trip not found or canceled")
        return
      end

      if trip.FINISHED?
        trip.rating = rating
        trip.save!
        calculate_rating(trip.driver_id)
      else
        errors.add(:error, "Trip is not finished yet")
      end
    end

    def calculate_rating(driver_id)
      trips = Trip.where(driver_id: driver_id, rating: 1..5)
      total_rating = trips.sum(:rating)
      rate = total_rating / trips.count
      Driver.find_by(id: driver_id).update!(rating: rate)
    end

  end
end
