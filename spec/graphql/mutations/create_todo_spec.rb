# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateTodo, type: :request do
  def create_query
    <<~GQL
      mutation CreateTodo($name: String!, $completed: Boolean!) {
        createTodo(
          name: $name, 
          completed: $completed) {
            id,
            name,
            completed
        }
      }
    GQL
  end

  let(:todo) { { name: 'task1', completed: false } }

  describe '.resolve' do
    subject { post '/graphql', params: params, as: :json }
    let(:params) { { query: create_query, variables: todo } }

    it 'creates a todo' do
      expect { subject
      }.to change { Todo.count }.by(1)
    end

    it 'returns the created todo' do
      subject
      data = JSON.parse(response.body)['data']['createTodo']

      expect(data['id']).to be_present
      expect(data['name']).to eq(todo[:name])
      expect(data['completed']).to eq(todo[:completed])
    end
  end
end