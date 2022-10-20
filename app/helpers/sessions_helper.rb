module SessionsHelper
  def add_session_tickets id
    session[:tickets_id] = [] if session[:tickets_id].blank?
    session[:tickets_id] << id
  end

  def delete_session_ticket id
    session[:tickets_id].delete(id)
  end

  def destroy_instances_seats
    return if session[:tickets_id].blank?

    session[:tickets_id].each do |ticket_id|
      ticket = Ticket.find_by(id: ticket_id)
      next if ticket.blank?

      ticket.seat.destroy
    end
    session.delete(:tickets_id)
  end

  def load_seats
    @seats = []
    session[:tickets_id].each do |ticket_id|
      ticket = Ticket.find_by(id: ticket_id)
      @seats << ticket.seat.seat_number
    end
    @seats.join(", ")
  end

  def load_payments
    tickets = []
    return if session[:tickets_id].blank?

    session[:tickets_id].each do |ticket_id|
      ticket = Ticket.find_by(id: ticket_id)
      tickets << ticket
    end
    tickets
  end

  def check_tickets_status
    session[:tickets_id].each do |ticket_id|
      ticket = Ticket.find_by(id: ticket_id)
      show_time_id = ticket.show_time.id
      seat_number = ticket.seat_number
      show_time = ShowTime.find_by(id: show_time_id)
      next unless show_time.seats.find_by(seat_number: seat_number,
                                          status: "unavailable")

      flash[:error] = t "payment_invalid"
      redirect_to root_path
    end
  end

  def save_payment id
    Payment.transaction do
      total_cost = session[:tickets_id].length * Settings.price.standard
      payment = Payment.find_by(id: id)
      payment.update(status: :approve,
                     total_cost: total_cost)
    end
  end

  def save_ticket id
    save_payment id
    return false if session[:tickets_id].blank?

    ticket_transaction = Ticket.transaction do
      session[:tickets_id].each do |ticket_id|
        ticket = Ticket.find_by(id: ticket_id)
        next unless ticket.update(payment_id: id)

        ticket.seat.unavailable!
      end
      true
    rescue ActiveRecord::Rollback
      false
    end

    session[:tickets_id] = []
    ticket_transaction
  end
end

def redirect_back_or default
  redirect_to(session[:forwarding_url] || default)
  session.delete(:forwarding_url)
end

def store_location
  session[:forwarding_url] = request.original_url if request.get?
end
