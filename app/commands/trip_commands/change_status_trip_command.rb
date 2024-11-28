# frozen_string_literal: true

module TripCommands
  class ChangeStatusTripCommand

    attr_accessor :driver_id, :trip_id, :status
    prepend SimpleCommand
    # include ActiveModel::Validations

    def initialize(driver_id, trip_id, status)
      @driver_id = driver_id
      @trip_id = trip_id
      @status = status
    end

    def call
      cmd = TripValidator::ChangeStatusTripValidator.call(params: {
        driver_id: driver_id.to_i,
        trip_id: trip_id.to_i,
        status: status
      })

      if cmd.failure?
        errors.add(:error, cmd.errors)
        return
      end

      trip = (status == :CANCELED) ?
               Trip.lock.find_by(id: trip_id) :
               Trip.lock.find_by(id: trip_id, trip_status: Trip.trip_statuses[status.to_sym] - 1)

      if trip.nil?
        errors.add(:error, "Trip not found")
        return
      end

      driver = Driver.lock.find_by(id: driver_id)

      if driver.nil?
        errors.add(:error, "Driver not found")
        return
      end

      return unless check_trip_cant_change_status(trip, status.to_sym)

      if status.to_sym == :FINISHED
        unless Payment.check_payment_enough(trip_id, trip.total_price)
          errors.add(:error, "Trip is not paid yet")
          return
        end
        driver.is_available = true
        driver.balance -= trip.fee
        driver.save!

        DriverBalanceTransaction.create_transaction(
          driver.id,
          -trip.fee,
          driver.balance,
          DriverBalanceTransaction.transaction_types[:trip_fee]
        )

      end

      trip.trip_status = Trip.trip_statuses[@status.to_sym].to_i
      if @status == :IN_PROCESS
        trip.start_time_real = Time.zone.now
      end
      trip.save!

    end

    def check_trip_cant_change_status(trip, to_status)
      if trip&.CANCELED? || trip&.FINISHED?
        errors.add(:error, "Trip is already canceled or finished")
        return false
      end

      if (trip&.trip_status == Trip.trip_statuses[:ARRIVED] || trip&.trip_status == Trip.trip_statuses[:IN_PROCESS]) && to_status == :CANCELED
        errors.add(:error, "Trip is already arrived or in process and can't be canceled")
        return false
      end

      true
    end

  end
end
