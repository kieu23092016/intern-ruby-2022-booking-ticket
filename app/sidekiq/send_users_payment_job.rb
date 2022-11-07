class SendUsersPaymentJob
  include Sidekiq::Job

  def perform user_id
    user = User.find_by(id: user_id)
    UserMailer.ticket_payment(user).deliver_later
  end
end
