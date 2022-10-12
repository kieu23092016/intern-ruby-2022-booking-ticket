FactoryBot.define do
  factory :show_time do
    start_time {Time.now + 1}
    movie {FactoryBot.create :movie}
    movie_id {movie.id}
    room {FactoryBot.create :room}
    room_id {room.id} 
  end
end
