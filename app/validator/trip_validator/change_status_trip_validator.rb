# frozen_string_literal: true

module TripValidator
  class ChangeStatusTripValidator < ParamsChecker::BaseParamsChecker
    INVALID_STATUS = [ Trip.trip_statuses[:IN_PROCESS], Trip.trip_statuses[:CANCELED], Trip.trip_statuses[:FINISHED], Trip.trip_statuses[:ARRIVED] ]
    def schema
      {
        driver_id: int_field,
        trip_id: int_field,
        status: char_field
      }
    end

    def check_status(status)
      unless INVALID_STATUS.include?(Trip.trip_statuses[status.to_sym])
        raise_error("Invalid status")
      end
      status
    end
  end
end
