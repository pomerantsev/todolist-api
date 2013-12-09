require 'spec_helper'

describe Users::SessionsController do
  describe "POST #create" do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context "with valid params" do
      let!(:user) { create :user, password: "12345678" }
      let(:user_params) { { email: user.email, password: "12345678" } }
      let(:action) { post :create, user: user_params }
      it "responds with 'ok' status" do
        action
        expect(response.status).to eq 200
      end
      it "responds with the user's authentication token" do
        action
        expect(JSON.parse(response.body)['auth_token'])
          .to eq User.last.authentication_token
      end
    end

    context "with invalid params" do
      before { post :create, user: {} }
      it "responds with 'unauthorized' status" do
        expect(response.status).to eq 401
      end
      it "responds with a 'Login failed' message" do
        expect(JSON.parse(response.body)['info']).to eq "Login failed"
      end
    end

  end
end
