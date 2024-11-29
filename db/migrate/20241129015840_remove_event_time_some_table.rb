class RemoveEventTimeSomeTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :time_event, :datetime
    remove_column :arrivals, :end_time_real, :datetime

    add_column :trips, :end_time_real, :datetime
  end
end
