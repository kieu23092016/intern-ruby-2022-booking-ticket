start=1000000000
puts "create user"
user_name = "Kiều Anh"
email = "kieu23092016@gmail.com"
password = "123456"
User.create!(user_name: user_name,
  email: email,
  phone: 1987654321,
  password: password,
  password_confirmation: password,
  admin: true)
10.times do |n|
  user_name = "Michael Harlt"
  email = "example-#{n + 1}@gmail.com"
  password = "password"
  User.create!(user_name: user_name,
    email: email,
    phone: start,
    password: password,
    password_confirmation: password)
    start = start+1
end

puts "create category"
names=["Horror", "Action", "Romantic", "Adventure", "Comedy"]
names.each {|name|
  Category.create!(name: name)
}

puts "create cinema"

cinemaNames = ["Galaxy Nguyễn Du", "Galaxy Tân Bình", "Galaxy Kinh Dương", "Galazy Quang Trung", "Galaxy Mipec Long Bien"]
cinemaNames.each {|cinemaName|
  Cinema.create!(location: "Cầu Giấy", name: cinemaName)
}

puts "create room"

cinemas = Cinema.all
10.times do
  index = 1
  cinemas.each { |cinema|
    cinema.rooms.create!(row: 6, length: 8, name: "Phòng #{index}")
    index += 1
  }
end

puts "create movie"

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

puts "create showtime"
time = Time.now + 1
movies = Movie.all
rooms = Room.all
movies.each{ |movie|
  rooms.sample(10).each{ |room|
    start_time = time
    end_time = start_time + 2*60*60
    ShowTime.create!(
      start_time: start_time, end_time: end_time, movie_id: movie.id, room_id: room.id
    )
    time = end_time + 1
  }
}

puts "create seat"

users = User.all[1..10]
show_times = ShowTime.all.each{ |show_time|
  room = show_time.room
  index = 1
  room.row.times do |i|
    room.length.times do
      price = 65000
      seat_type = [1,2].sample
      status = [1,3].sample
      seat_number = Settings.seat_code.seat_letter[i] + index.to_s
      if status == 3
        Seat.create!(
          seat_type: seat_type, status: status, show_time_id: show_time.id, seat_number: seat_number
        )
      end
      index += 1
    end
  end
}
