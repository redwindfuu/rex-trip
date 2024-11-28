# frozen_string_literal: true

module TripValidator
  class ApproveTripValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        driver_id: int_field,
        trip_id: int_field
      }
    end
  end
end
