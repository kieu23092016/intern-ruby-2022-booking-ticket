require "rails_helper"
include SessionsHelper
RSpec.describe ShowTimesController, type: :controller do
  let(:user){FactoryBot.create :user}
  let(:movie){FactoryBot.create :movie}
  let!(:cinema){FactoryBot.create :cinema}
  let!(:room){FactoryBot.create :room, cinema_id: cinema.id}
  let!(:show_time) do
    FactoryBot.create :show_time, start_time: (Date.today + 1).to_s + " 10:15:15.000000000 UTC +00:00", 
    movie_id: movie.id, 
    room_id: room.id
  end
  let(:seat)do 
    FactoryBot.create :seat, show_time_id: show_time.id, 
                                      status: 2
  end
  let(:ticket)do 
    FactoryBot.create :ticket, seat_id: seat.id,
                              show_time_id: show_time.id
  end
  before do 
    sign_in user
  end
  describe "#load_show_time_info" do 
    it "shoulld return room, seats, movie when start time valid" do 
      get :show, params:{id: show_time.id}
      expect(assigns(:room)).to eq(room)
      expect(assigns(:seats)).to eq([seat])
      expect(assigns(:movie)).to eq(movie)
    end
    it "should flash showtime not found" do 
      allow_any_instance_of(ShowTime).to receive(:start_time).and_return((Date.today-1).to_s + " 10:15:15.000000000 UTC +00:00")
      get :show, params:{id: show_time.id}
      expect(flash[:error]).to eq(I18n.t("show_time_not_found"))
    end
  end
end