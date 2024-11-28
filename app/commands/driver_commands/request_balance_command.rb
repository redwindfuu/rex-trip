# frozen_string_literal: true

module DriverCommands
  class RequestBalanceCommand

    prepend SimpleCommand

    attr_accessor :driver_id, :amount, :type

    def initialize(driver_id, amount, type)
      @driver_id = driver_id
      @amount = amount
      @type = type
    end

    def call
      validator = DriverValidator::RequestBalanceValidator.call(params: {
        driver_id: driver_id,
        amount: amount,
        type: type
      })

      if validator.failure?
        errors.add(:error, validator.errors)
        return
      end

      driver = Driver.find_by(id: driver_id)

      if driver.nil?
        errors.add(:error, "Driver not found")
        return
      end

      if type == :withdrawn && driver.balance < amount
        errors.add(:error, "Balance is not enough")
        return
      end

      ActiveRecord::Base.transaction do
        DriverBalanceTransaction.create_transaction(
          driver.id,
          amount,
          driver.balance + amount,
          DriverBalanceTransaction.types[type]
        )
      end

    end

  end
end
