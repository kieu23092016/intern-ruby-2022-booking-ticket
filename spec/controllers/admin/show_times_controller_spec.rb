require "rails_helper"
include SessionsHelper
RSpec.describe Admin::ShowTimesController, type: :controller do
  let(:movie){FactoryBot.create :movie}
  let!(:cinema){FactoryBot.create :cinema}
  let!(:room){FactoryBot.create :room, cinema_id: cinema.id}
  let!(:show_time) do
    FactoryBot.create :show_time, start_time: (Date.today + 1).to_s + " 10:15:15.000000000 UTC +00:00", 
                                movie_id: movie.id, 
                                room_id: room.id
  end
  let!(:show_time2) do
    FactoryBot.create :show_time, start_time: (Date.today + 2).to_s + " 10:15:15.000000000 UTC +00:00", 
                                movie_id: movie.id, 
                                room_id: room.id
  end
  let!(:seat){FactoryBot.create :seat, show_time_id: show_time2.id}
  let(:user){FactoryBot.create :user}
  before do 
    sign_in user
  end
  describe "GET#index" do 
    context "when movie not found" do 
      it "should flash error film not found " do 
        get :index, params:{movie_id: -1}
        expect(flash[:error]).to eq(I18n.t("film_not_found"))
      end
      it "should redirect to admin movies path" do 
        get :index, params:{movie_id: -1}
        expect(response).to redirect_to admin_movies_path
      end
    end
    it "should return if find movie" do 
      get :index, params:{movie_id: movie.id}
      expect(assigns(:show_times)).to eq([show_time, show_time2])
    end
  end
  describe "GET#new" do 
    it "should create a new showtime" do 
      get :new, params:{movie_id: movie.id} 
      expect(assigns(:show_time)).to be_a_new(ShowTime)
    end
  end
  describe "POST#create" do 
    context "when create showtime fail" do 
      before do 
        post :create, params: {
          movie_id: movie.id, 
          show_time:{
            start_time: "2001/09/23"
          }
        }
      end
      it "should flash error start time" do
        expect(flash[:error]).to eq(I18n.t("time_invalid"))
      end
      it "should redirect to admin showtime path" do 
        expect(response).to redirect_to(admin_movie_show_times_path(movie_id: movie.id))
      end
    end
    context "when create showtime success" do 
      before do 
        post :create, params: {
          movie_id: movie.id, 
          show_time:{
            start_time: (Date.today + 2).to_s + " 20:15:15.000000000 UTC +00:00",
            room_id: room.id
          }
        }
      end
      it "should flash success created" do 
        expect(flash[:success]).to eq(I18n.t("st_updated"))
      end
      it "should redirect to admin showtime path" do 
        expect(response).to redirect_to(admin_movie_show_times_path(movie_id: movie.id))
      end
    end
  end
  describe "GET#edit" do 
    context "when showtime is not found" do 
      it "should flash error film ot found" do 
        get :edit, params:{movie_id: movie.id ,id: -1}
        expect(flash[:error]).to eq(I18n.t("showtime_not_found"))
      end
      it "should redirect to admin showtime root path" do 
        get :edit, params:{movie_id: movie.id, id: -1}
        expect(response).to redirect_to admin_movie_show_times_path(movie_id: movie.id)
      end
    end
    it "should showtime is valid" do 
      get :edit, params:{movie_id: movie.id, id: show_time.id}
      expect(assigns(:show_time)).to eq(show_time)
    end
  end
  describe "#error_del_method" do 
    context "when can't delete when showtimes have booking" do 
      it "should flash error cant delete" do 
        delete :destroy, params:{movie_id: movie.id, id: show_time2.id}
        expect(flash[:error]).to eq(I18n.t("seats"))
      end
      it "should redirect to admin_showtimes_movies_path" do 
        delete :destroy, params:{movie_id: movie.id, id: show_time2.id}
        expect(response).to redirect_to admin_movie_show_times_path(movie_id: movie.id)
      end
    end
  end
  describe "DELETE#destroy" do 
    context "when sucess delete showtime" do 
      it "should flash delete success" do 
        delete :destroy, params:{movie_id: movie.id, id: show_time.id}
        expect(flash[:success]).to eq(I18n.t("deleted"))
      end
      it "should redirect_to admin_showtimes_path" do
        delete :destroy, params:{movie_id: movie.id, id: show_time.id}
        expect(response).to redirect_to admin_movie_show_times_path(movie_id: movie.id)
      end
    end
    context "when fail delete showtime" do 
      it "should flash delete failed" do 
        allow_any_instance_of(ShowTime).to receive(:destroy).and_return(false)
        delete :destroy, params:{movie_id: movie.id, id: show_time.id}
        expect(flash[:error]).to eq(I18n.t("not_deleted"))
      end
      it "should redirect_to admin_showtimes_movies_path" do
        allow_any_instance_of(Movie).to receive(:destroy).and_return(false)
        delete :destroy, params:{movie_id: movie.id, id: show_time.id}
        expect(response).to redirect_to admin_movie_show_times_path(movie_id: movie.id)
      end
    end
  end
  describe "PATCH#update" do 
    context "when success when valid attributes" do
      before do
        patch :update, params: {
          movie_id: movie.id, 
          id: show_time.id, 
          show_time:{
            start_time: (Date.today + 3).to_s + " 10:15:15.000000000 UTC +00:00", 
          }
        }
      end
      it "should flash success when update success" do
        expect(flash[:success]).to eq(I18n.t("changed"))
      end
      it "should redirects to the admin_showtimes_movie_path" do
        expect(response).to redirect_to admin_movie_show_times_path(movie_id: movie.id)
      end
    end
    context "when fail when valid attributes" do 
      before do
        patch :update, params: {
          movie_id: movie.id, 
          id: show_time2.id,
          show_time:{
            start_time: (Date.today + 3).to_s + " 10:15:15.000000000 UTC +00:00", 
          }
        }
      end
      it "should flash update failed" do
        expect(flash[:error]).to eq(I18n.t("seats"))
      end
      it "should render edit" do 
        expect(response).to render_template("edit")
      end
    end
  end 
end