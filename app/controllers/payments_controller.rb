class PaymentsController < ApplicationController
  before_action :load_payments_info, only: %i(show)
  before_action :check_tickets_status, only: %i(create)

  def index
    @payments = current_user.payments.where(status: :approve)
  end

  def show
    return if @tickets.present?

    flash[:error] = t "payment_invalid"
    redirect_to root_path
  end

  def create
    save_ticket
    @user = current_user
    SendUsersPaymentJob.perform_in(10.minutes, @user.id)
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
