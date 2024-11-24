class Trip < ApplicationRecord
  enum trip_status: { WAITING_DRIVER_APPROVE: 0, WAITING_ARRIVE: 1, IN_PROCESS: 2, FINISHED: 3 }
  belongs_to :driver
  belongs_to :customer
  belongs_to :depart_place, class_name: Place.name, foreign_key: :depart_place_id
  has_many :arrivals, dependent: :destroy
end
