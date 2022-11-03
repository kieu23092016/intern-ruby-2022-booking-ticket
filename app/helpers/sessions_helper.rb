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
      tickets << ticket if ticket
    end
    tickets
  end

  def check_tickets_status
    session[:tickets_id].each do |ticket_id|
      ticket = Ticket.find_by(id: ticket_id)
      next if ticket

      flash[:error] = t "payment_invalid"
      redirect_to root_path
    end
  end

  def save_payment
    Payment.transaction do
      total_cost = session[:tickets_id].length * Settings.price.standard
      ticket_id = session[:tickets_id].first
      payment_id = Ticket.find_by(id: ticket_id).payment_id
      payment = Payment.find_by(id: payment_id)
      payment.update(status: :approve,
                     total_cost: total_cost)
    end
  end

  def save_ticket
    save_payment
    return false if session[:tickets_id].blank?

    ticket_transaction = Ticket.transaction do
      session[:tickets_id].each do |ticket_id|
        ticket = Ticket.find_by(id: ticket_id)
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
