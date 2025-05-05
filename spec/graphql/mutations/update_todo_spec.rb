# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateTodo, type: :request do
  def update_query
    <<~GQL
      mutation UpdateTodo($id: ID!, $name: String, $completed: Boolean) {
        updateTodo(id: $id, name: $name, completed: $completed) {
          id
          name
          completed
        }
      }
    GQL
  end

  let(:new_todo) { { name: 'new task', completed: true } }
  let(:parsed_body) { JSON.parse(response.body)['data']['updateTodo'] }

  describe '.resolve' do
    let!(:todo) { create(:todo, name: "old task") }

    subject { post '/graphql', params: params, as: :json }

    context 'when name and completed are provided' do
      let(:params) { { query: update_query, variables: { id: todo.id,
                                                         name: new_todo[:name],
                                                         completed: new_todo[:completed] } } }
      it 'updates both name and completed fields' do
        subject

        expect(parsed_body["name"]).to eq(new_todo[:name])
        expect(parsed_body["completed"]).to eq(new_todo[:completed])
      end
    end

    context 'when just the name is provided' do
      let(:params) { { query: update_query, variables: { id: todo.id,
                                                         name: new_todo[:name] } } }
      it "updates only the name field" do
        subject

        expect(parsed_body["name"]).to eq(new_todo[:name])
        expect(parsed_body["completed"]).to eq(todo[:completed])
      end
    end

    context 'when just the completed status is provided' do
      let(:params) { { query: update_query, variables: { id: todo.id,
                                                         completed: new_todo[:completed] } } }
      it "updates only the completed field" do
        subject

        expect(parsed_body["name"]).to eq(todo[:name])
        expect(parsed_body["completed"]).to eq(new_todo[:completed])
      end
    end
  end
end
