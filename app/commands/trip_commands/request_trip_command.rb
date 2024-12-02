# frozen_string_literal: true

module TripCommands
  class RequestTripCommand
    prepend SimpleCommand
    FEE_RATE = 0.2

    attr_accessor :customer_id, :trip_params

    def initialize(customer_id, trip_params)
      @customer_id = customer_id
      @trip_params = trip_params
    end

    def call
      validator = TripValidator::RequestTripValidator.call(params: trip_params.merge!({ customer_id: customer_id }))

      if validator.failure?
        errors.add(:error, validator.errors)
        return nil
      end

      arrive_list = trip_params[:froms]
      arrive_list.sort_by! { |place| place[:order] }
      fee_price = BigDecimal("0")
      total_time = 0
      from_id = trip_params[:to_place_id]
      to_id = arrive_list[0][:from_place_id]

      arrive_list.each_with_index do |arrive, index|
        expense = PlaceExpense.get_expense_between_places(from_id, to_id)
        if expense.nil?
          errors.add(:error, "Can't find expense between #{from_id} and #{to_id}")
          return nil
        end
        arrive.merge!({ price: expense[:price].to_d, time_of_expense: expense[:time_of_expense] })
        from_id = arrive[:from_place_id]
        to_id = arrive_list[index + 1]&.[](:from_place_id)
      end

      ActiveRecord::Base.transaction do
        trip = Trip.create(customer_id: customer_id, depart_place_id: trip_params[:to_place_id], seat: trip_params[:seat], trip_status: Trip.trip_statuses[:WAITING_DRIVER_APPROVE], fee_rate: FEE_RATE)
        trip.start_time_est = Time.now + 5.minutes

        trip.save!
        arrive_list.each do |arrive|
          fee_price += arrive[:price]
          total_time += arrive[:time_of_expense]
          Arrival.create(trip_id: trip.id, place_id: arrive[:from_place_id], name: arrive[:name], order_place: arrive[:order],  end_time_est: trip.start_time_est + total_time)
        end
        trip.total_price = fee_price
        trip.fee = fee_price * FEE_RATE
        trip.save
        trip
      end
    end
  end
end
