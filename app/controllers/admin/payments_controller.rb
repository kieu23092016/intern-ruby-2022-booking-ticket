class Admin::PaymentsController < AdminController
  skip_before_action :search_movies
  before_action :find_payment, only: %i(show)

  def index
    @q = Payment.ransack(params[:search])
    @payments = @q.result(distinct: true)
    @pagy, @payments = pagy @payments.sort_list,
                            items: Settings.digits.admin_movie_per_page
  end

  def show
    @tickets = @payment.tickets
  end

  private

  def find_payment
    @payment = Payment.find_by id: params[:id]
    return if @payment

    flash[:error] = t "pm_not_found"
    redirect_to admin_payments_path
  end
end
