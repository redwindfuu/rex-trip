class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest
      t.string :role
      t.timestamps
    end
  end
end
