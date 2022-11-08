require "rails_helper"
include SessionsHelper
RSpec.describe Admin::UsersController, type: :controller do 
  let!(:user)do 
    FactoryBot.create :user, user_name: FFaker::Internet.email.downcase, 
                            email: FFaker::Internet.email.downcase, 
                            phone: "1987654322", activated: 1,
                            admin: false
  end
  let!(:user2)do 
  FactoryBot.create :user, user_name: FFaker::Internet.email.downcase, 
                          email: FFaker::Internet.email.downcase, 
                          phone: "1987654323",
                          admin: false
  end
  let(:admin){FactoryBot.create :user}
  before do 
    sign_in admin
  end
  describe "#find_user" do 
    context "when user not found" do 
      it "should flash error not found user" do 
        get :edit, params:{id: -1}
        expect(flash[:error]).to eq(I18n.t("not_found_user"))
      end
      it "should redirect to admin_users_path" do 
        get :edit, params:{id: -1}
        expect(response).to redirect_to admin_users_path
      end
    end 
    it "should return if find user" do 
      get :destroy, params:{id: user.id}
      expect(assigns(:user)).to eq(user)
    end
  end
end