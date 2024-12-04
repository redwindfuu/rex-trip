class CreateInviteesFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :invitees_friends do |t|
      t.references :from, polymorphic: true, null: false # Polymorphic inviter
      t.references :to, polymorphic: true, null: false   # Polymorphic invitee
      t.timestamps
    end

    add_index :invitees_friends, [:from_id, :from_type]
    add_index :invitees_friends, [:to_id, :to_type]
    
  end
end
