class CreateDriverBalanceTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :driver_balance_transactions do |t|
      t.uuid :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.references :driver, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :balance_after, precision: 10, scale: 2
      t.integer :type
      t.integer :status
      t.references :approved_by,  foreign_key: { to_table: :admins }, null: true
      t.datetime :approved_at
      t.datetime :requested_at
      t.timestamps
    end
  end
end
