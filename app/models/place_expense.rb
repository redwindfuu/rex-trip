class PlaceExpense < ApplicationRecord
  
  belongs_to :from_place, class_name: "Place", foreign_key: "from_place_id"
  belongs_to :to_place, class_name: "Place", foreign_key: "to_place_id"
  
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  def self.create_expense(from_place_id, to_place_id, price)
    PlaceExpense.create(from_place_id: from_place_id, to_place_id: to_place_id, price: price)
  end
  
  def self.get_expense_of_place(place_id)
    PlaceExpense.where("from_place_id = ? OR to_place_id = ?", place_id, place_id)
  end
  
  def self.get_expense_between_places(from_place_id, to_place_id)
    PlaceExpense.where("from_place_id = ? AND to_place_id = ? OR from_place_id = ? AND to_place_id = ?", from_place_id, to_place_id, to_place_id, from_place_id)
  end
  
end
