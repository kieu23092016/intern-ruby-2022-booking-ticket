FactoryBot.define do
  factory :payment do
    status {2}
    user {FactoryBot.create :user}
    user_id {user.id} 
  end
end
  