FactoryBot.define do
  factory :ticket do
    price {700000}
    show_time {FactoryBot.create :show_time}
    show_time_id {show_time.id} 
    seat {FactoryBot.create :seat}
    seat_id {seat.id}
    payment {FactoryBot.create :payment}
    payment_id {payment.id}
  end
end
    