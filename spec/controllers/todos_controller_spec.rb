# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TodosController, type: :controller do
  before(:each) do
    Todo.delete_all
  end

  let(:parsed_body) { JSON.parse(response.body) }

  describe "POST #create" do
    subject { post :create, params: params }

    let(:params) { { todo: { name: "Task1", completed: true } } }

    it "should create todo successfully" do
      subject

      expect(response).to have_http_status(:created)
      expect(parsed_body['name']).to eq("Task1")
      expect(parsed_body['completed']).to eq(true)
    end

    context "when 'completed' field is empty" do
      let(:params) { { todo: { name: "Task2" } } }

      it "should create todo successfully" do
        subject

        expect(response).to have_http_status(:created)
        expect(parsed_body['name']).to eq("Task2")
        expect(parsed_body['completed']).to eq(false)
      end
    end

    context "when 'name' field is empty" do
      let(:params) { {} }

      it "should return unprocessable entity" do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #index" do
    subject { get :index }

    it "should list no todos when the todos list is empty" do
      subject

      expect(response).to have_http_status(:ok)
      expect(parsed_body['todos']).to be_empty
    end

    context "when the list is not empty" do
      before do
        Todo.create(name: "Task1", completed: true)
        Todo.create(name: "Task2")
      end

      it "should list all todos" do
        subject

        expect(response).to have_http_status(:ok)
        expect(parsed_body['todos'].length).to eq(2)
        expect(parsed_body['todos'].first['name']).to eq("Task1")
        expect(parsed_body['todos'][0]['completed']).to eq(true)
        expect(parsed_body['todos'][1]['name']).to eq("Task2")
        expect(parsed_body['todos'][1]['completed']).to eq(false)
      end
    end
  end

  describe "PUT #todos" do
    let!(:todo) { Todo.create(name: "Task1") }
    subject { put :update, params: params }

    context "when the todo exists" do
      let(:params) { { id: todo.id, todo: { name: "Updated task", completed: true } } }

      it "updates the todo successfully" do
        subject

        expect(response).to have_http_status(:ok)
        expect(parsed_body['name']).to eq("Updated task")
        expect(parsed_body['completed']).to eq(true)
      end
    end

    context "when the todo does not exist" do
      let(:params) { { id: 100, todo: { name: "Task", completed: true } } }
      subject { put :update, params: params }

      it "returns not found" do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "when the list is not empty" do
    before do
      Todo.create(name: "Task1", completed: true)
      Todo.create(name: "Task2")
    end

    describe "DELETE #destroy" do
      let!(:todo) { Todo.create(name: "Task3", completed: false) }
      subject { delete :destroy, params: params }

      context "when the todo exists" do
        let(:params) { { id: todo.id } }

        it "deletes the todo successfully" do
          subject

          expect(response).to have_http_status(:ok)
          expect(parsed_body['message']).to eq("Todo deleted")
        end
      end

      context "when todo doesn't exist" do
        let(:params) { { id: 100 } }
        
        it "returns not found" do
          subject

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #delete_all" do
      subject { delete :delete_all }

      it "should delete all todos" do
        subject

        expect(response).to have_http_status(:ok)
        expect(parsed_body['message']).to eq("All todos have been deleted")
        expect(Todo.count).to eq(0)
      end
    end
  end
end