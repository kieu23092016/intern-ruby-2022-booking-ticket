module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    return unless (user_id = session[:user_id])

    @current_user ||= User.find_by(id: user_id)
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    session.delete(:tickets_id)
    @current_user = nil
  end

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
    @seats
  end
end
