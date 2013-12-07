require 'spec_helper'

describe TodosController do
  describe "GET #index" do
    let!(:todo) { create :todo }
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(response.body).to eq [todo].to_json
    end
  end
end
