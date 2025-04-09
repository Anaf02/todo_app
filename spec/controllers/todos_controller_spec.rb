# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TodosController, type: :controller do

  describe "POST #create" do
    it "creates todo successfully" do
      post :create, params: { todo: { name: "Task1", completed: true } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq("Task1")
    end

    it "unprocessable entity when todo name is empty" do
      post :create, params: { todo: {} }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end