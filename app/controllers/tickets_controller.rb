class TicketsController < ApplicationController
  before_action :load_show_time_info

  def show
    destroy_instances_seats
  end

  def create
    @seat = Seat.create(seat_number: params[:seat_number],
                        show_time_id: @show_time.id,
                        status: Settings.ticket_status.choosen,
                        seat_type: Settings.seat_type.standard)
    @ticket = Ticket.create(price: Settings.price.standard, seat_id: @seat.id)
    add_session_tickets @ticket.id
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @seat = Seat.find_by(id: params[:seat_id])
    return unless @seat

    respond_to do |format|
      format.js
    end
    delete_session_ticket @seat.ticket.id
    @seat.destroy
  end

  private

  def load_show_time_info
    @show_time = ShowTime.find_by id: params[:id]
    if @show_time
      @room = @show_time.room
      @seats = @show_time.seats
      @movie = @show_time.movie
    else
      flash[:danger] = t "show_time_not_found"
      redirect_to root_path
    end
  end
end
