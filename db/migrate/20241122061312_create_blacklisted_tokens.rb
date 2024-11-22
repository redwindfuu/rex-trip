class CreateBlacklistedTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :blacklisted_tokens do |t|
      t.uuid :uuid
      t.string :type
      t.datetime :revoked_at
      t.string :token, null: false
      t.timestamps
    end
    add_index :blacklisted_tokens, :token, unique: true
  end
end
