class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.uuid :uuid, default: -> { "gen_random_uuid()" }, null: false, index: true, unique: true
      t.references :trip, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :time_event, null: true
      t.integer :method, default: 0
      t.integer :status

      t.timestamps
    end
  end
end
