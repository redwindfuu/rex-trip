# frozen_string_literal: true

module DriverValidator
  class RequestBalanceValidator < ParamsChecker::BaseParamsChecker

    INVALID_TYPE = [ DriverBalanceTransaction.types[:deposited], DriverBalanceTransaction.types[:withdraw] ]
    def schema
      {
        driver_id: int_field,
        amount: int_field,
        type: char_field
      }
    end

    def check_type(type)
      if INVALID_TYPE.include?(DriverBalanceTransaction.types[type.to_sym])
        type
      else
        raise_error("Type is invalid")
      end
    end

  end
end
