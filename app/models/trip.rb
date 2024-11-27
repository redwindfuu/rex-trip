require "bigdecimal"

class Trip < ApplicationRecord
  enum trip_status: { WAITING_DRIVER_APPROVE: 0, WAITING_ARRIVE: 1, IN_PROCESS: 2, ARRIVED: 3, FINISHED: 4, CANCELED: 5 }

  belongs_to :driver
  belongs_to :customer
  belongs_to :depart_place, class_name: Place.name, foreign_key: :depart_place_id

  has_many :arrivals, dependent: :destroy
  has_many :payments, dependent: :destroy



  before_create :before_request


  def before_request
    self.booking_time = Time.zone.now
    self.fight_no = SecureRandom.hex(12)
  end


end
