# frozen_string_literal: true

module TripCommands
  class PayTripCommand
    prepend SimpleCommand

    attr_accessor :trip_id, :amount

    def initialize(trip_id , amount)
      @trip_id = trip_id
      @amount = amount
    end

    def call
      if amount <= 0
        errors.add(:error, "Amount must be greater than 0")
        return
      end
      trip = Trip.find_by(id: @trip_id)

      if trip.nil? || trip.FINISHED? || trip.CANCELED?
        errors.add(:error, "Trip not found or finished or canceled")
        return
      end

      # need more test about concurrency
      ActiveRecord::Base.transaction do
        total_paid = Payment.where(trip_id: trip_id).sum(:amount) # Tính tổng mà không khóa
        if total_paid + amount > trip.total_price
          errors.add(:error, "Amount paid exceeds total price")
          return
        end

        payments = Payment.where(trip_id: trip_id).lock # Khóa bản ghi để ngăn cập nhật song song
        Payment.create!(trip_id: trip_id, amount: amount)
      end
    end

  end
end
