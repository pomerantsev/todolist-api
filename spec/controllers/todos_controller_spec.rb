require 'spec_helper'

describe TodosController do
  context "when not signed in" do
    describe "GET #index" do
      let!(:todo) { create :todo }
      it "responds with unauthorized status" do
        get :index
        expect(response.status).to eq 401
      end

      it "responds with an empty body" do
        get :index
        expect(response.body).to be_blank
      end
    end
  end

  context "when signed in" do
    let(:user) { create :user }
    before { sign_in user }
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
      before { post :create, todo_params }
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

    describe "PATCH #update" do
      let(:todo) { create(:todo) }
      let(:valid_params) { { title: "Do something else" } }
      context "when the update is valid" do
        before { patch :update, { id: todo }.merge(valid_params) }
        it "updates the todo" do
          expect(todo.reload.title).to eq "Do something else"
        end
        it "responds with 'no_content' status" do
          expect(response.status).to eq 204
        end
      end

      context "when the update is invalid" do
        let(:invalid_params) { { title: "" } }
        let(:errors) { todo.update(invalid_params); todo.errors }
        before { patch :update, { id: todo }.merge(invalid_params) }
        it "responds with 'unprocessable entity' status" do
          expect(response.status).to eq 422
        end
        it "renders the errors for the todo" do
          expect(response.body).to eq errors.to_json
        end
      end

      context "when the todo doesn't exist" do
        it "responds with a not_found response" do
          patch :update, { id: 1000 }.merge(valid_params)
          expect(response.status).to eq(404)
        end
      end
    end

    describe "DELETE #destroy" do
      let(:todo) { create(:todo) }
      context "when the todo exists" do
        it "destroys the todo" do
          todo
          expect do
            delete :destroy, id: todo
          end.to change(Todo, :count).by -1
        end
        it "responds with a 'no content' header" do
          delete :destroy, id: todo
          expect(response.status).to eq 204
        end
      end

      context "when the todo doesn't exist" do
        it "responds with a not_found response" do
          delete :destroy, id: 1000
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
