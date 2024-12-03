class RenameInInviteesFriend < ActiveRecord::Migration[7.0]
  def change
    rename_column :invitees_friends, :from_id, :inviter_id
    rename_column :invitees_friends, :from_type, :inviter_type
    rename_column :invitees_friends, :to_id, :inviteable_id
    rename_column :invitees_friends, :to_type, :inviteable_type
  end
end
