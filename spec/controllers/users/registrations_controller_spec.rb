require 'spec_helper'

describe Users::RegistrationsController do
  describe "POST #create" do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context "with valid params" do
      let(:user_params) { attributes_for :user }
      let(:action) { post :create, user: user_params }
      it "registers the new user" do
        expect { action }.to change(User, :count).by 1
      end
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
      let(:errors) { User.create({}).errors }
      it "responds with 'unprocessable entity' status" do
        expect(response.status).to eq 422
      end
      it "renders the errors for the todo" do
        expect(response.body).to eq errors.to_json
      end
    end

  end
end
