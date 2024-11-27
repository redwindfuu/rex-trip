# frozen_string_literal: true

module TripCommands
  class ChangeStatusTripCommand

    prepend SimpleCommand

    def initialize(driver_id, trip_id, status)
      @driver_id = driver_id
      @trip_id = trip_id
      @status = status
    end
    INVALID_STATUS = [ Trip.trip_statuses[:IN_PROCESS], Trip.trip_statuses[:CANCELED], Trip.trip_statuses[:FINISHED], Trip.trip_statuses[:ARRIVED] ]
    def call
      raise Errors::BadRequest unless @driver_id && @trip_id
      raise Errors::BadRequest unless INVALID_STATUS.include?(Trip.trip_statuses[@status.to_sym])
      Trip.transaction do

        trip = @status == :CANCELED ? Trip.lock.find_by(id: @trip_id) : Trip.find_by(id: @trip_id, status: Trip.trip_statuses[@status.to_sym] - 1)

        raise Errors::NotFound, "Trip not found" unless trip

        check_trip_cant_change_status(trip , @status)

        if @status == :FINISHED
          raise Errors::BadRequest, "Trip is not paid yet" unless Payment.check_payment_enough(@trip_id, trip.total_price)
        end


        trip.status = Trip.trip_statuses[@status.to_sym].to_i
        if @status == :IN_PROCESS
          trip.start_time_real = Time.zone.now
        end
        trip.save!
      end
    end

    def check_trip_cant_change_status(trip , to_status)
      if trip&.CANCELED? || trip&.FINISHED?
        raise Errors::BadRequest, "Trip is already canceled"
      end

      if trip&.status == Trip.trip_statuses[:ARRIVED] && to_status == :CANCELED
        raise Errors::BadRequest, "Trip is already arrived and can't be canceled"
      end

    end

  end
end
