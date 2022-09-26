module PaymentHelper
  def total_cost tickets
    tickets.size * Settings.price.standard
  end
end
