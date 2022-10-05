class Seat < ApplicationRecord
  enum status: {available: 1, choosen: 2, unavailable: 3}
  enum seat_type: {standard: 1, vip: 2}
  has_one :ticket, dependent: :destroy
  belongs_to :show_time
  delegate :start_time, to: :show_time
end
