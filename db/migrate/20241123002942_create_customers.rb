class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.uuid :uuid, default: -> { "uuid_generate_v4()" }, null: false
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :avatar_link
      t.string :username
      t.string :password_digest
      t.integer :amount_invite
      t.string :invite_code, unique: true
      t.timestamps
    end
  end
end
