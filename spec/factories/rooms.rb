FactoryBot.define do
  factory :room do
    row {8}
    length {6}
    cinema {FactoryBot.create :cinema}
    cinema_id {cinema.id}
    name {"Phong 1"} 
  end
end
