class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.uuid :uuid, default: -> { "uuid_generate_v4()" }, null: false
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :avatar_link
      t.string :front_side_link
      t.string :backside_link
      t.string :id_number
      t.string :username
      t.string :password_digest
      t.decimal :balance
      t.boolean :is_available
      t.float :rating_avg
      t.integer :amount_invite
      t.string :invite_code, unique: true
      t.column :status, :integer, default: 0
      t.datetime :kyc_at

      t.references :kyc_by, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
