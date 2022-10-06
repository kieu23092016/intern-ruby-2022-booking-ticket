class PaymentsController < ApplicationController
  before_action :load_payments_info, only: %i(show)
  before_action :check_tickets_status, only: %i(create)

  def index
    @payments = current_user.payments.where(status: :approve)
  end

  def show
    return if @tickets

    flash[:error] = t "payment_invalid"
    redirect_to root_path
  end

  def create
    @payment = Payment.create(status: :pending,
                              user_id: current_user.id)
    save_ticket @payment.id
    @user = current_user
    @user.create_activation_digest
    @user.send_noti_booking_email
    flash[:success] = t "payment_success"
    redirect_to root_path
  end

  private

  def load_payments_info
    @show_time = ShowTime.find_by id: params[:id]
    return unless @show_time

    @room = @show_time.room
    @movie = @show_time.movie
    @tickets = load_payments
  end
end
