class CreateInvitedFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :invited_friends do |t|
      t.uuid :to_uuid, null: false
      t.uuid :from_uuid, null: false
      t.string :invite_code, null: false
      t.integer :type, null: false
      t.timestamps
    end
  end
end
