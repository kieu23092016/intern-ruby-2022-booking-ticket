FactoryBot.define do
  factory :cinema do
    name {"Galaxy" + FFaker::AddressUS.state}
    location {FFaker::AddressUS.city}
  end
end
