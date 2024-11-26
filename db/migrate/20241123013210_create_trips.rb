class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.uuid :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.string :fight_no
      t.references :driver, foreign_key: true, null: true
      t.references :customer, foreign_key: true
      t.references :depart_place, foreign_key: { to_table: :places }
      t.datetime :booking_time
      t.integer :seat
      t.datetime :start_time_est
      t.datetime :start_time_real
      t.column :status, :integer, default: 0
      t.integer :rating
      t.decimal :total_price
      t.decimal :est_price
      t.decimal :fee
      t.float :fee_rate

      t.index :fight_no, unique: true
      t.index :booking_time, name: 'index_trips_on_booking_time'
      t.timestamps
    end
  end
end

