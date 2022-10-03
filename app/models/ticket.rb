class Ticket < ApplicationRecord
  belongs_to :payment, optional: true
  belongs_to :seat

  delegate :seat_number, to: :seat
  delegate :show_time, to: :seat
  delegate :cinema_name, to: :show_time
  delegate :movie_title, to: :show_time
  delegate :room_name, to: :show_time
  delegate :start_time, to: :show_time
end
