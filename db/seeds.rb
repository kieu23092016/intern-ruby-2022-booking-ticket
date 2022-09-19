start=1231231231

50.times do |n|
  user_name = "Michael Harlt"
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(user_name: user_name,
    email: email,
    phone: start,
    password: password,
    password_confirmation: password)
    start = start+1
end

names=["Horror", "Action", "Romantic", "Adventure", "Comedy"]
names.each {|name|
  Category.create!(name: name)
}

cinemaNames = ["Galaxy Nguyễn Du", "Galaxy Tân Bình", "Galaxy Kinh Dương", "Galazy Quang Trung", "Galaxy Mipec Long Bien"]
cinemaNames.each {|cinemaName|
  Cinema.create!(location: "Cầu Giấy", name: cinemaName)
}
cinemas = Cinema.all
10.times do
  cinemas.each { |cinema| cinema.rooms.create!(row: 20, length: 30) }
end



50.times do
  title = "Before Sunrise"
  description = "While travelling on a train in Europe, Jesse, an American man, meets Celine, a French woman. On his last day in Europe before returning to the US, he decides to spend his remaining hours with her."
  rating = 4.2
  duration_min = 120
  release_time = "9/9/2022"
  language = "English"
  director = "Jon Watts"
  cast = "Tom Holland, Zendaya"
  age_range = "Under 18"
  category_id = 2
  img_link = "https://cdn.galaxycine.vn/media/2022/8/29/1200-x-1800_1661753251433.jpg"
  director = "Faker"
  cast = "Ethen Hawkey, July Delphy"
  age_range = "Under 18"
  category_id = 2
  img_link = "https://cdn-amz.woka.io/images/I/91BLbWDAAkL.jpg"
  Movie.create!(title: title, description: description, rating: rating,
                 duration_min: duration_min, release_time: release_time,
                 language: language, director: director, cast: cast,
                 age_range: age_range, category_id: category_id, img_link: img_link)
end
time = Time.now
movies = Movie.all
rooms = Room.all
movies.each{ |movie|
  rooms.sample(10).each{ |room|
    start_time = time
    end_time = start_time + 2*60*60
    ShowTime.create!(
      start_time: start_time, end_time: end_time, movie_id: movie.id, room_id: room.id
    )
    time = end_time
  }
}
