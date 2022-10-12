FactoryBot.define do
  factory :movie do
    title {FFaker::Movie.title}
    release_time {"10/10/2022"}
    duration_min {120}
  end
end
