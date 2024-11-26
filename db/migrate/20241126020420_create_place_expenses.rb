class CreatePlaceExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :place_expenses do |t|

      t.references :from_place, null: false, foreign_key: { to_table: :places }
      t.references :to_place, null: false, foreign_key: { to_table: :places }

      t.decimal :price, precision: 10, scale: 2


      t.timestamps
    end
  end
end
