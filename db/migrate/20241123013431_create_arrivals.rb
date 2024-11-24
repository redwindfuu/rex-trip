class CreateArrivals < ActiveRecord::Migration[7.0]
  def change
    create_table :arrivals do |t|
      t.string :name
      t.references :place, foreign_key: true
      t.references :trip, foreign_key: true, type: :uuid
      t.integer :order_place
      t.datetime :end_time_est
      t.datetime :end_time_real
      t.timestamps
    end
  end
end
