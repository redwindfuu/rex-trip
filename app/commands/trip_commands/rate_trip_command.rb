# frozen_string_literal: true

module TripCommands
  class RateTripCommand
    prepend SimpleCommand

    attr_accessor :trip_id, :rating, :customer_id

    def initialize(trip_id, rating, customer_id)
      @trip_id = trip_id
      @rating = rating
      @customer_id = customer_id
    end

    def call
      cmd = TripValidator::RateTripValidator.call(params: {
        trip_id: trip_id.to_i,
        rating: rating,
        customer_id: customer_id
      })

      if cmd.failure?
        errors.add(:error, cmd.errors)
        return
      end

      trip = Trip.find_by(id: trip_id.to_i)

      if trip.nil? || trip.CANCELED? || trip.customer_id != customer_id
        errors.add(:error, "Trip not be rated")
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
      Driver.find_by(id: driver_id).update!(rating_avg: rate)
    end
  end
end
