module TicketsHelper
  def seat_status seats, seat_number
    seat = seats.find_by(seat_number: seat_number)
    seat&.unavailable? || seat&.choosen?
  end
end
