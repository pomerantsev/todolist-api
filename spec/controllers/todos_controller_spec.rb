require 'spec_helper'

describe TodosController do
  shared_examples "not signed in" do
    it "responds with unauthorized status" do
      expect(response.status).to eq 401
    end
    it "responds with an empty body" do
      expect(response.body).to be_blank
    end
  end

  shared_examples "forbidden" do
    it "responds with a 'forbidden' response" do
      expect(response.status).to eq 403
    end
  end

  let(:user) { create :user }

  describe "GET #index" do
    let!(:todo1) { create :todo, user: user }
    let!(:todo2) { create :todo, user: user }
    let!(:todo3) { create :todo, user: create(:user) }
    context "when signed in" do
      before { sign_in user }
      it "responds with the user's todos index" do
        get :index
        expect(response.status).to eq(200)
        expect(response.body).to eq [todo1, todo2].to_json
      end
    end

    context "when not signed in" do
      before { get :index }
      it_behaves_like "not signed in"
    end
  end

  describe "GET #show" do
    let(:todo) { create :todo, user: user }
    context "when signed in" do
      before { sign_in user }
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

      context "when the todo belongs to another user" do
        let(:another_todo) { create :todo, user: create(:user) }
        before { get :show, id: another_todo }
        it_behaves_like "forbidden"
      end
    end

    context "when not signed in" do
      before { get :show, id: todo }
      it_behaves_like "not signed in"
    end
  end

  describe "POST #create" do
    context "when signed in" do
      before do
        sign_in user
        post :create, todo_params
      end
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

    context "when not signed in" do
      before { post :create, attributes_for(:todo) }
      it_behaves_like "not signed in"
    end
  end

  describe "PATCH #update" do
    let(:todo) { create :todo, user: user }
    let(:valid_params) { { title: "Do something else" } }
    context "when signed in" do
      before { sign_in user }
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

      context "when the todo belongs to another user" do
        let(:another_todo) { create :todo, user: create(:user) }
        before { patch :update, { id: another_todo }.merge(valid_params) }
        it_behaves_like "forbidden"
      end
    end

    context "when not signed in" do
      before { patch :update, { id: todo }.merge(valid_params) }
      it_behaves_like "not signed in"
    end
  end

  describe "DELETE #destroy" do
    let!(:todo) { create :todo, user: user }
    context "when signed in" do
      before { sign_in user }
      context "when the todo exists" do
        it "destroys the todo" do
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

      context "when the todo belongs to another user" do
        let!(:another_todo) { create :todo, user: create(:user) }
        before { delete :destroy, id: another_todo }
        it_behaves_like "forbidden"
      end
    end

    context "when not signed in" do
      before { delete :destroy, id: todo }
      it_behaves_like "not signed in"
    end
  end
end
