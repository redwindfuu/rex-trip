class AddTimeToPlaceExpense < ActiveRecord::Migration[7.0]
  def change
    add_column :place_expenses, :time_of_expense, :integer
  end
end
