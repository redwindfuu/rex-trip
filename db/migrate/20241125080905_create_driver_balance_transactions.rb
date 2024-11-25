class CreateDriverBalanceTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :driver_balance_transactions, id: :uuid do |t|
      t.references :driver, type: :uuid, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :balance_after, precision: 10, scale: 2
      t.integer :type
      t.integer :status
      t.references :approved_by, type: :uuid, foreign_key: { to_table: :admins }, null: true
      t.datetime :approved_at
      t.datetime :requested_at
      t.timestamps
    end
  end
end
