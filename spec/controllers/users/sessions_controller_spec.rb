require 'spec_helper'

describe Users::SessionsController do
  describe "POST #create" do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context "with valid params" do
      let!(:user) { create :user, password: "12345678" }
      let(:action) { post :create, user: { email: user.email,
                                           password: "12345678" } }
      it "responds with 'ok' status" do
        action
        expect(response.status).to eq 200
      end
      it "responds with the user's authentication token and success == true" do
        action
        expect(JSON.parse(response.body)['auth_token'])
          .to eq User.last.authentication_token
        expect(JSON.parse(response.body)['success']).to eq true
      end
    end

    context "with invalid params" do
      shared_examples "failed login" do
        it "responds with 'ok' status" do
          expect(response.status).to eq 200
        end
        it "responds with a 'Login failed' message and success == false" do
          expect(JSON.parse(response.body)['success']).to eq false
          expect(JSON.parse(response.body)['info']).to eq "Login failed"
        end
      end

      context "when there is no such user in the database" do
        before { post :create, user: { email: "some_email@example.com",
                                       password: "some_password" } }
        it_behaves_like "failed login"
      end

      context "when the password is incorrect" do
        let(:user) { create :user, password: "some_password" }
        before { post :create, user: { email: user.email,
                                       password: "incorrect_password" } }
        it_behaves_like "failed login"
      end
    end

  end
end
