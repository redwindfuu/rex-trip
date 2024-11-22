class CreateAdminAgain < ActiveRecord::Migration[8.0]
  def change
    create_table :admins, id: :uuid do |t|
        t.string :username
        t.string :password_digest
        t.string :role
        t.timestamps
    end
  end
end
