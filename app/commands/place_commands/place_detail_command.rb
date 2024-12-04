# frozen_string_literal: true

module PlaceCommands
  class PlaceDetailCommand
    prepend SimpleCommand

    def initialize(place_id)
      @place_id = place_id
    end

    def call  
      place = Place.find_by(id: @place_id)
      unless place
        errors.add(:base, "Place not found")
        return nil
      end
      all_place = PlaceExpense.get_expense_of_place(@place_id)
      PlaceSerializer.new(place, place_expenses: all_place.to_a)
    end
  end
end
