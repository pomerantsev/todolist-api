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
    let(:todo) { create :todo }
    context "when the todo exists" do
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

  describe "POST #create" do
    before { post :create, todo: todo_params }
    context "with a valid todo" do
      let(:todo_params) { attributes_for(:todo) }
      let(:todo) { Todo.last }
      it "responds with 'created' status" do
        expect(response.status).to eq(201)
      end
      it "renders the todo" do
        expect(response.body).to eq todo.to_json
      end
      it "includes the path to the newly created record" do
        expect(response.location).to eq todo_url(todo)
      end
    end

    context "with an invalid todo" do
      let(:todo_params) { attributes_for(:todo, title: "") }
      let(:errors) { Todo.create(todo_params).errors }
      it "responds with 'unprocessable entity' status" do
        expect(response.status).to eq 422
      end
      it "renders the errors for the todo" do
        expect(response.body).to eq errors.to_json
      end
    end
  end
end
