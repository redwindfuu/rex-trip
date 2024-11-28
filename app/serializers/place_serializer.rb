# frozen_string_literal: true

class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :place_expenses, if: :detail

  def detail
    !@instance_options[:place_expenses].nil? && @instance_options[:place_expenses].length > 0
  end

  def place_expenses
    place_expenses =  @instance_options[:place_expenses]
    place_expenses.map! do |place_expense|
      to_place_id = object.id == place_expense.from_place_id ? place_expense.to_place_id : place_expense.from_place_id
      {
        to_id: to_place_id,
        to_name: place_expense.to_place.name,
        price: place_expense.price
      }
    end
  end

end
