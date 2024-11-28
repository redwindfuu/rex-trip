# frozen_string_literal: true

module TripValidator
  class RateTripValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        trip_id: int_field,
        rating: int_field,
        customer_id: int_field
      }
    end

    def check_rating
      if rating < 1 || rating > 5
        raise_error("Rating must be between 1 and 5")
      end
      rating
    end

  end
end
