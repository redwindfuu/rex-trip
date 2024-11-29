# == Schema Information
#
# Table name: trips
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  fight_no        :string
#  driver_id       :bigint
#  customer_id     :bigint
#  depart_place_id :bigint
#  booking_time    :datetime
#  seat            :integer
#  start_time_est  :datetime
#  start_time_real :datetime
#  trip_status     :integer          default("WAITING_DRIVER_APPROVE")
#  rating          :integer
#  total_price     :decimal(, )
#  est_price       :decimal(, )
#  fee             :decimal(, )
#  fee_rate        :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "bigdecimal"

class Trip < ApplicationRecord
  enum trip_status: { WAITING_DRIVER_APPROVE: 0, WAITING_ARRIVE: 1, IN_PROCESS: 2, ARRIVED: 3, FINISHED: 4, CANCELED: 5 }

  belongs_to :driver, optional: true
  belongs_to :customer
  belongs_to :depart_place, class_name: Place.name, foreign_key: :depart_place_id

  has_many :arrivals, dependent: :destroy
  has_many :payments, dependent: :destroy


  validates :seat, presence: true, numericality: { greater_than: 0 }

  before_create :before_request


  def before_request
    self.booking_time = Time.zone.now
    self.fight_no = SecureRandom.hex(12)
  end

  def self.get_available
    Trip
      .where(trip_status: Trip.trip_statuses[:WAITING_DRIVER_APPROVE])
  end
end
