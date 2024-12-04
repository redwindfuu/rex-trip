module PlaceCommands
  class PreCalculateCommand
    prepend SimpleCommand

    attr_accessor :place_id, :tos
    def initialize(place_id, tos)
      @place_id = place_id     
      @tos = tos
    end

    def call
      validate_params = PlaceValidator::CalculateValidator.call(params: { place_id: @place_id, tos: @tos })

      if validate_params.failure?
        errors.add(:base, validate_params.errors)
        return nil
      end
      price = 0
      from_id = place_id
      tos.sort_by! { |to| to[:order] }

      tos.each_with_index do |to, index|
        to_id = to[:to_place_id]
        price += PlaceExpense.get_expense_between_places(from_id.to_i, to_id.to_i).price
        from_id = to_id
      end
      price
    end
  end
end
