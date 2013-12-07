require 'spec_helper'

describe TodosController do
  describe "GET #index" do
    let!(:todo1) { create :todo }
    let!(:todo2) { create :todo }
    it "responds with the todos index" do
      get :index
      expect(response.status).to eq(200)
      expect(response.body).to eq [todo1, todo2].to_json
    end
  end

  describe "GET #show" do
    context "when the todo exists" do
      let!(:todo) { create :todo }
      it "responds with the requested todo" do
        get :show, id: todo
        expect(response.status).to eq(200)
        expect(response.body).to eq todo.to_json
      end
    end

    context "when the todo doesn't exist" do
      it "responds with a not_found response" do
        get :show, id: 1000
        expect(response.status).to eq(404)
      end
    end
  end
end
