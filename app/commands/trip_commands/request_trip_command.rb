 # frozen_string_literal: true

module TripCommands
  class RequestTripCommand
    prepend SimpleCommand
    FEE_RATE = 0.2
    def initialize(customer_id, trip_params)
      @customer_id = customer_id
      @trip_params = trip_params
    end

    def call
      raise Errors::BadRequest unless @customer_id && @trip_params
      arrive_list = @trip_params[:froms]
      ActiveRecord::Base.transaction do
        fee_price = BigDecimal("0")
        trip = Trip.create(customer_id: @customer_id, depart_place_id: @trip_params[:depart_place_id], seat: @trip_params[:seat], trip_status: Trip.trip_statuses[:WAITING_DRIVER_APPROVE], fee_rate: FEE_RATE)
        trip.start_time_est = Time.now + 5.minutes
        trip.save
        total_time = 0
        from_id = depart_place_id
        to_id = arrive_list[0]
        arrive_list.sort_by! { |place| place.order }
        arrive_list.each do |arrive, index|
          expense = PlaceExpense.get_expense_between_places(from_id, to_id)
          if expense.nil?
            raise Errors::NotFound, "Expense not found between #{from_id} and #{to_id}"
          end
          fee_price += expense.price.to_d
          total_time += expense.time_of_expense
          Arrival.create(trip_id: trip.id, place_id: arrive, name: arrive.name, order_place: arrive.order,  end_time_est: trip.start_time_est + total_time.time_of_expense)
          from_id = arrive
          to_id = arrive_list[index + 1]
        end
        trip.total_price = fee_price
        trip.fee = fee_price * FEE_RATE
        trip.save
      end
    end
  end
end
