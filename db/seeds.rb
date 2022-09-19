
start=1234567890

99.times do |n|
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
  title = "Spider-Man: No Way Home"
  description = "Spider-Man: No Way Home is a 2021 American superhero film based on the Marvel Comics character Spider-Man, co-produced by Columbia Pictures and Marvel "
  rating = 4.2
  duration_min = 120
  release_time = "9/9/2022"
  language = "English"
  director = "Jon Watts"
  cast = "Tom Holland, Zendaya"
  age_range = "Under 18"
  category_id = 2
  img_link = "https://cdn.galaxycine.vn/media/2022/8/29/1200-x-1800_1661753251433.jpg"
  Movie.create!(title: title, description: description, rating: rating,
                 duration_min: duration_min, release_time: release_time,
                 language: language, director: director, cast: cast,
                 age_range: age_range, category_id: category_id, img_link: img_link)
  end

movies = Movie.all
rooms = Room.all
movies.each{ |movie|
  rooms.each{ |room|
    start_time = "1/9/2022"
    end_time = "10/9/2022"
    ShowTime.create!(
      start_time: start_time, end_time: end_time, movie_id: movie.id, room_id: room.id
    )
  }
}
