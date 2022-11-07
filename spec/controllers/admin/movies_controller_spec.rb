require "rails_helper"
include SessionsHelper
RSpec.describe Admin::MoviesController, type: :controller do
  # test ci
  let(:category1){FactoryBot.create :category}
  let(:category2){FactoryBot.create :category}
  let(:movie1){FactoryBot.create :movie}
  let(:movie2){FactoryBot.create :movie}
  let!(:cinema){FactoryBot.create :cinema}
  let!(:room){FactoryBot.create :room, cinema_id: cinema.id}
  let!(:show_time) do
    FactoryBot.create :show_time, start_time: (Date.today + 1).to_s + " 10:15:15.000000000 UTC +00:00", 
                                movie_id: movie1.id, 
                                room_id: room.id
  end
  let(:user){FactoryBot.create :user}
  before do 
    sign_in user
  end
  describe "GET#index" do
    it "should show the list of movies" do
      get :index
      expect(assigns(:movies)).to eq([movie1, movie2])
    end
  end 
  describe "GET#show" do 
    context "when failed when movie not found" do 
      it "should flash error film ot found" do 
        get :show, params:{id: -1}
        expect(flash[:error]).to eq(I18n.t("film_not_found"))
      end
      it "should redirect to admin root path" do 
        get :show, params:{id: -1}
        expect(response).to redirect_to admin_root_path
      end
    end
    context "when success found categories" do 
      let!(:movie_categories1){FactoryBot.create :movie_category, movie_id: movie1.id, category_id: category1.id}
      let!(:movie_categories2){FactoryBot.create :movie_category, movie_id: movie1.id, category_id: category2.id} 
      it "should list categories belong to the movie" do
        get :show, params:{id: movie1.id}
        expect(assigns(:categories)).to eq([category1.name, category2.name])
      end
    end
  end
  describe "GET#new" do
    it "should create a new movie" do
      get :new
      expect(assigns(:movie)).to be_a_new(Movie)
    end
  end
  describe "PATCH#update" do 
    context "when success when valid attributes" do
      before do
        patch :update, params: {
          id: movie1.id,
          movie: {title: "Before Sunrise"}
        }
      end
      it "should flash success when update success" do
        expect(flash[:success]).to eq(I18n.t("changed"))
      end
      it "should redirects to the admin_movie_path" do
        expect(response).to redirect_to admin_movie_path(id: movie1.id)
      end
    end
    context "when fail when valid attributes" do 
      before do
        patch :update, params: {
          id: movie1.id,
          movie: {title:""}
        }
      end
      it "should flash update failed" do
        expect(flash[:error]).to eq(I18n.t("not_changed"))
      end
      it "should render edit" do 
        expect(response).to render_template("edit")
      end
    end
  end 
  describe "DELETE#destroy" do 
    context "when sucess delete movie" do 
      it "should flash delete success" do 
        delete :destroy, params:{id: movie2.id}
        expect(flash[:success]).to eq(I18n.t("deleted"))
      end
      it "should redirect_to admin_movies_path" do
        delete :destroy, params:{id: movie2.id}
        expect(response).to redirect_to(admin_movies_path)
      end
    end
    context "when fail delete movie" do 
      it "should flash delete failed" do 
        allow_any_instance_of(Movie).to receive(:destroy).and_return(false)
        delete :destroy, params:{id: movie2.id}
        expect(flash[:error]).to eq(I18n.t("not_deleted"))
      end
      it "should redirect_to admin_movies_path" do
        allow_any_instance_of(Movie).to receive(:destroy).and_return(false)
        delete :destroy, params:{id: movie2.id}
        expect(response).to redirect_to(admin_movies_path)
      end
    end
  end
  describe "POST#create" do 
    context "when sucess create movie" do
      before do
        post :create, params: {
          movie: {
            title: "Before Sunrise",
            release_time: "12/10/2022",
            duration_min: 120
          }
        }
      end 
      it "should flash success created" do 
        expect(flash[:success]).to eq(I18n.t("updated"))
      end
      it "should redirect to admin_movie_path" do 
        expect(response).to redirect_to(admin_movie_path(id: Movie.last.id))
      end 
    end
    context "when failed create movie" do 
      before do
        post :create, params: {
          movie: {
            title: ""
          }
        }
      end 
      it "should flash error not created" do
        expect(flash[:error]).to eq(I18n.t("not_updated"))
      end 
      it "should render new" do 
        expect(response).to render_template("new") 
      end
    end
  end
  describe "#error_del_method" do 
    context "when can't delete when movie have showtimes" do 
      it "should flash error cant delete" do 
        delete :destroy, params:{id: movie1.id}
        expect(flash[:error]).to eq(I18n.t("not_del"))
      end
      it "should redirect to admin_movies_path" do 
        delete :destroy, params:{id: movie1.id}
        expect(response).to redirect_to admin_movies_path
      end
    end
  end
  describe "GET#edit" do 
    it "should movie is valid" do 
      get :edit, params:{id: movie2.id}
      expect(assigns(:movie)).to eq(movie2)
    end
    context "when movie is not found" do 
      it "should flash error film ot found" do 
        get :edit, params:{id: -1}
        expect(flash[:error]).to eq(I18n.t("film_not_found"))
      end
      it "should redirect to admin root path" do 
        get :edit, params:{id: -1}
        expect(response).to redirect_to admin_root_path
      end
    end
  end
end
