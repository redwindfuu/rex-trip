class RenameColumnInDriverBalanceTransaction < ActiveRecord::Migration[7.0]
  def change
    rename_column :driver_balance_transactions, :type, :transaction_type
    rename_column :driver_balance_transactions, :status, :transaction_status
  end
end
