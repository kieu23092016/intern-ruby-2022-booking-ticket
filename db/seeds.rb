names=["Horror", "Action", "Romantic", "Adventure", "Comedy"]
names.each {|name|
  Category.create!(name: name)
}

50.times do 
  title = Faker::Movies::Lebowski.actor
  description = Faker::Movie.quote
  rating = 4.2
  duration_min = 120
  release_time = "9/9/2022"
  language = "English"
  director = "Faker"
  cast = Faker::Movies::Lebowski.actor
  age_range = "Under 18"
  category_id = 2
  img_link = "https://cdn.galaxycine.vn/media/2022/8/29/1200-x-1800_1661753251433.jpg"
  Movie.create!(title: title, description: description, rating: rating, 
                 duration_min: duration_min, release_time: release_time,
                 language: language, director: director, cast: cast,
                 age_range: age_range, category_id: category_id, img_link: img_link)
end
