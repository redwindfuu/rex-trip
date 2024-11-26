# frozen_string_literal: true

module TripValidator
  class RequestTripValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        to_place_id: int_field,
        froms: arr_field,
        seat: int_field,
      }
    end

    # [{ from_place_id: int, order: int }]
    def check_froms
      froms = @params[:froms]
      froms.each do |from|
        from_place_id = from[:from_place_id]
        order = from[:order]
        raise_error("from_place_id is required") if from_place_id.nil?
        raise_error("order is required") if order.nil?
        raise_error("order must be a number") unless order.is_a?(Integer)
      end
    end

  end
end
