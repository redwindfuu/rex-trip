class RenameColumnInInvitedFriend < ActiveRecord::Migration[7.0]
  def change
    rename_column :invited_friends, :type, :invite_type
  end
end
