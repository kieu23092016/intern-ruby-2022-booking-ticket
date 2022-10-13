FactoryBot.define do
  factory :seat do
    seat_type {"standard"}
    status {"unavailable"}
    show_time {FactoryBot.create :show_time}
    show_time_id {show_time.id} 
    seat_number {"A1"}
  end
end
