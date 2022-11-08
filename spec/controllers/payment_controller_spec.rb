require "rails_helper"
include SessionsHelper
RSpec.describe PaymentsController, type: :controller do
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
  let(:payment1){FactoryBot.create :payment, user_id: user.id}
  let(:payment2){FactoryBot.create :payment, user_id: user.id}
  let(:ticket)do 
    FactoryBot.create :ticket, seat_id: seat.id,
                              show_time_id: show_time.id,
                              payment_id: payment1.id
  end

  before do 
    sign_in user
  end
  describe "GET#index" do 
    it "should return payments list when ticket status true" do 
      get :index 
      expect(assigns(:payments)).to eq([payment1, payment2]) 
    end
  end
  describe "#load_payments_info" do 
    it "should return false when showtime not found" do
      get :show, params:{id: -1}
      expect(flash[:error]).to eq(I18n.t("payment_invalid"))
    end
    it "should return value of room, movie when found showtime" do
      request.session[:tickets_id] = [ticket.id]
      get :show, params:{id: show_time.id}
      expect(assigns(:room)).to eq(room)
      expect(assigns(:movie)).to eq(movie)
      expect(assigns(:tickets)).to eq([ticket])
    end
  end
  describe "GET#show" do 
    context "when ticket not found" do 
      it "should flash error payment invalid" do 
        get :show, params: {id: -1}
        expect(flash[:error]).to eq(I18n.t("payment_invalid"))
      end
      it "should redirect to root path" do 
        get :show, params: {id: -1}
        expect(response).to redirect_to root_path
      end
    end
    it "should render show payment when ticket present" do
      request.session[:tickets_id] = [ticket.id]
      get :show, params: {id: show_time.id}
      expect(response).to render_template("show")
    end
  end
  describe "POST#create" do 
    context "when ticket is available" do 
      before do 
        request.session[:tickets_id] = [ticket.id]
        post :create
      end
      it "should flash payment success" do 
        expect(flash[:success]).to eq(I18n.t("payment_success"))
      end 
      it "should redirect to rooth path" do 
        expect(response).to redirect_to root_path
      end
    end 
    context "when check ticket not found" do 
      before do
        request.session[:tickets_id] = [-1]
        post :create
      end
      it "should flash payment invalid" do 
        expect(flash[:error]).to eq(I18n.t("payment_invalid"))
      end
      it "should redirect to root path" do 
        expect(response).to redirect_to root_path
      end
    end
  end
end