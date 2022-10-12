FactoryBot.define do
  factory :movie_category do 
    movie {FactoryBot.create :movie}
    movie_id {movie.id}
    category {FactoryBot.create :category}
    category_id {category.id}
  end
end
