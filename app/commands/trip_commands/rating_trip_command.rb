# frozen_string_literal: true

module TripCommands
  class RatingTripCommand
    prepend SimpleCommand
    attr_accessor :customer_id, :trip_id, :rating
    def initialize(customer_id, trip_id, rating)
      @customer_id = customer_id
      @trip_id = trip_id
      @rating = rating
    end

    def call
      validator = TripValidator::RatingTripValidator.call(params: {
        customer_id: customer_id.to_i,
        trip_id: trip_id.to_i,
        rating: rating.to_i
      })
      
      if validator.failure?
        errors.add(:errors, validator.errors)
        return nil
      end
      
      trip = Trip.find_by(id: trip_id , customer_id: customer_id)
      return nil if trip.nil?
      
      trip.rating = rating.to_i
      trip.save!
      trip
    end
  end
end
