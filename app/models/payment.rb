# == Schema Information
#
# Table name: payments
#
#  id         :bigint           not null, primary key
#  uuid       :uuid             not null
#  trip_id    :bigint           not null
#  amount     :decimal(10, 2)
#  method     :integer          default("cash")
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Payment < ApplicationRecord
  has_one :trip

  validates :amount, presence: true, numericality: { greater_than: 0 }

  enum method: { cash: 0, credit_card: 1, visa: 2, master_card: 3, paypal: 4 }

  enum status: { pending: 0, success: 1, failed: 2 }

  before_create :before_request

  def before_request
    self.status = Payment.statuses[:success]
    trip = Trip.find_by(id: self.trip_id)
    if trip.payments.sum(:amount) + self.amount > trip.total_price
      errors.add(:error, "Amount paid exceeds total price")
    end
  end

  def self.check_payment_enough(trip_id, total)
    payments = Payment.where(trip_id: trip_id)
    total_payment = payments.sum(:amount)
    total_payment >= total
  end
end
