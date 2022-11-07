class ShowTimesController < ApplicationController
  load_and_authorize_resource
  before_action :load_show_time_info
  def show
    destroy_instances_seats
  end

  def create
    Payment.transaction do
      @payment = Payment.create!(status: :pending,
                                 user_id: current_user.id)
      @seat = Seat.create!(seat_number: params[:seat_number],
                           show_time_id: @show_time.id,
                           status: :choosen,
                           seat_type: :standard)
      @ticket = Ticket.create!(price: Settings.price.standard,
                               seat_id: @seat.id, payment_id: @payment.id)
    end
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
    @payment = @seat.ticket.payment
    @seat.destroy
    @payment.destroy
  end

  private

  def load_show_time_info
    @show_time = ShowTime.find_by id: params[:id]
    if @show_time.start_time > Time.current
      @room = @show_time.room
      @seats = @show_time.seats
      @movie = @show_time.movie
    else
      flash[:error] = t "show_time_not_found"
      redirect_to root_path
    end
  end
end
