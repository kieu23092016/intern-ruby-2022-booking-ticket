require "rails_helper"

RSpec.describe ShowTime, type: :model do
  let(:movie){FactoryBot.create :movie}
  let(:cinema){FactoryBot.create :cinema}
  let(:room){FactoryBot.create :room, cinema_id: cinema.id}
  let!(:show_time_1) do
    FactoryBot.create :show_time, start_time: (Date.today + 1).to_s + " 07:15:15.000000000 UTC +00:00", 
                                  movie_id: movie.id, 
                                  room_id: room.id
  end
  let!(:show_time_2) do 
    FactoryBot.create :show_time, start_time: (Date.today + 1).to_s + " 10:15:15.000000000 UTC +00:00", 
                                  movie_id: movie.id, 
                                  room_id: room.id
  end
 
  let!(:seat_2_1){FactoryBot.create :seat, show_time_id: show_time_2.id}
  describe ".findroom" do 
    it "finding showtime in the same room" do 
      expect(ShowTime.find_room(room.id)).to eq([show_time_1, show_time_2])
    end
    it "not finding showtime in the same room" do 
      expect(ShowTime.find_room(-1)).to eq([])
    end
  end 
  describe ".overlap" do 
    it "finding overlap time" do 
      start_time = (Date.today + 1).to_s + " 8:15:15.000000000 UTC +00:00"
      end_time = (Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00"
      expect(ShowTime.overlap(start_time.to_datetime,end_time.to_datetime )).to eq([show_time_1, show_time_2])
    end 
    it "Not found overlap time" do 
      start_time = (Date.today).to_s + " 8:15:15.000000000 UTC +00:00"
      end_time = (Date.today).to_s + " 11:15:15.000000000 UTC +00:00"
      expect(ShowTime.overlap(start_time.to_datetime,end_time.to_datetime )).to eq([])
    end
  end
  describe "#valid_overlap_showtime" do
    it "overlap time add errors" do 
      show_time_3 = ShowTime.create(start_time: (Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00", 
      movie_id: movie.id, 
      room_id: room.id)
      expect(show_time_3.errors["start_time"]).to eq([I18n.t("time_overlap")])
    end
    it "not overlap time" do 
      show_time_3 = ShowTime.create(start_time: (Date.today + 2).to_s + " 11:15:15.000000000 UTC +00:00", 
      movie_id: movie.id, 
      room_id: room.id)
      expect(ShowTime.exists?(show_time_3.id)).to be true
    end
  end
  describe ".filterdate" do
    it "found filter date" do
      expect(ShowTime.filter_date(movie.id, Date.today + 1)).to eq([show_time_1, show_time_2])
    end 
    it "not found filter date" do
      expect(ShowTime.filter_date(movie.id, "4/10/2022")).to eq([])
    end
  end

  describe "#valid_change" do
    it "add errors when have seat" do 
      show_time_2.update(start_time: (Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00")
      expect(show_time_2.errors["seats"]).to eq([I18n.t("seats")])
    end
    it "update when have no seat" do 
      show_time_1.update(start_time: (Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00")
      expect(show_time_1.start_time).to eq(((Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00").to_datetime)     
    end
  end
  describe "#valid_format_showtime" do 
    it "start time is missing" do 
      show_time = ShowTime.create(movie_id: movie.id, room_id: room.id)
      expect(show_time.errors["start_time"]).to eq([I18n.t("time_ignore")])
    end 
    context "start time is present" do 
      it "start time is smaller than time current" do 
        start_time = "Mon, 10 Oct 2022 11:15:15.000000000 UTC +00:00"
        show_time = ShowTime.create(start_time: start_time.to_datetime, 
                                    movie_id: movie.id, room_id: room.id)
        expect(show_time.errors["start_time"]).to eq([I18n.t("time_invalid")])
      end
      it "start time is valid" do 
        start_time = (Date.today + 1).to_s + " 11:15:15.000000000 UTC +00:00"
        show_time = ShowTime.create(start_time: start_time.to_s, 
                                    movie_id: movie.id, room_id: room.id)
        expect(show_time.end_time).to eq(start_time.to_datetime + movie.duration_min.minutes)        
      end
    end
  end
end
