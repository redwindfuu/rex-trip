class DropAdminTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :admins
  end
end