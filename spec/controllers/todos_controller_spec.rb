# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TodosController, type: :controller do
  before(:each) do
    Todo.delete_all
  end

  describe "POST #create" do
    subject { post :create, params: params }

    let(:params) { { todo: { name: "Task1", completed: true } } }

    it "should create todo successfully" do
      subject

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq("Task1")
      expect(JSON.parse(response.body)['completed']).to eq(true)
    end

    context 'when completed field is empty' do
      let(:params) { { todo: { name: "Task2" } } }

      it "should create todo successfully" do
        subject

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq("Task2")
        expect(JSON.parse(response.body)['completed']).to eq(false)
      end
    end

    context 'when name field is empty' do
      let(:params) { {} }

      it "should return unprocessable entity" do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #index" do
    it "should list no todos when the todos list is empty" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['todos']).to be_empty
    end

    it "should list all todos when the list is not empty" do
      post :create, params: { todo: { name: "Task1", completed: true } }
      post :create, params: { todo: { name: "Task2" } }

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['todos'].length).to eq(2)
      expect(JSON.parse(response.body)['todos'][0]['name']).to eq("Task1")
      expect(JSON.parse(response.body)['todos'][0]['completed']).to eq(true)
      expect(JSON.parse(response.body)['todos'][1]['name']).to eq("Task2")
      expect(JSON.parse(response.body)['todos'][1]['completed']).to eq(false)
    end
  end

  describe "PUT #todos" do
    it "should update book successfully" do
      post :create, params: { todo: { name: "Task1", completed: true } }
      todo_id = JSON.parse(response.body)['id']

      put :update, params: { id: todo_id, todo: { name: "Updated task", completed: false } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq("Updated task")
      expect(JSON.parse(response.body)['completed']).to eq(false)
    end

    it "should return not found when the todo doesn't exist" do
      put :update, params: { id: 100, todo: { name: "Task", completed: true } }

      expect(response).to have_http_status(:not_found)
    end

  end

  describe "DELETE #destroy" do
    it "should delete todo successfully" do
      post :create, params: { todo: { name: "Task1", completed: true } }
      todo_id = JSON.parse(response.body)['id']

      delete :destroy, params: { id: todo_id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("Todo deleted")
    end

    it "should return not found when the todo doesn't exist" do
      delete :destroy, params: { id: 100 }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #delete_all" do
    it "should delete all todos" do
      post :create, params: { todo: { name: "Task1", completed: true } }
      post :create, params: { todo: { name: "Task2" } }

      delete :delete_all

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("All todos have been deleted")
      expect(Todo.count).to eq(0)
    end
  end
end