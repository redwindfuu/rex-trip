class RenameStatusToTrip < ActiveRecord::Migration[7.0]
  def change
    rename_column :trips, :status, :trip_status
  end
end
