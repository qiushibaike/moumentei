
describe SessionsController do
  context "there exists a user" do
    let(:user) { create :user, password: '123456', password_confirmation: '123456' }
    it "successfully login" do
      post :create, login: user.login, password: user.password
      #response.should be_success
      expect(session[:user_id]).to eq( user.id)
    end
  end

  context "there is no such user" do
    it "does not login" do
      post :create, login: 'test', password: '123456'
      expect(response).not_to be_success
      expect(session[:user_id]).to be_nil
    end
  end
end


