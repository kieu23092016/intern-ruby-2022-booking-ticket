module TicketsHelper
  def seat_status seats, seat_number
    seats.find_by(seat_number: seat_number)&.status
  end
end
