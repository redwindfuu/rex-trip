class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest
      t.string :role
      t.uuid :uuid

      t.timestamps
    end
  end
end
