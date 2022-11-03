require "rake"
namespace :delete_namespace do
  desc "delete payments expired"
  task delete_payments_expired: :environment do
    @payments = Payment.pending
    @payments.each do |payment|
      payment.tickets.each do |ticket|
        ticket.seat.destroy
      end
      payment.destroy if payment.payment_expired?
    end
  end
end
