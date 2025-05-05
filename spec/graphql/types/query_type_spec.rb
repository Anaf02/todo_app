# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Query Type', type: :request do
  def todos_query
    <<~GQL
      query Todos($name: String, $completed: Boolean, $page: Int, $perPage: Int) {
        todos(name: $name, completed: $completed, page: $page, perPage: $perPage) {
          id
          name
          completed
        }
      }
    GQL
  end

  let(:parsed_body) { JSON.parse(response.body)['data']['todos'] }

  describe '.resolve' do
    before(:each) do
      Todo.delete_all
      create(:todo, name: 'task1')
      create(:todo, :completed, name: 'task2')
      create(:todo, name: 'task3')
    end

    subject { post '/graphql', params: params, as: :json }
    let(:params) { { query: todos_query, variables: variables } }

    context 'when no filters are applied' do
      let(:variables) { { name: nil, completed: nil, page: nil, perPage: nil } }

      it 'returns all todos' do
        subject
        expect(parsed_body.size).to eq(3)
      end
    end

    context 'when filtering by completed status' do
      let(:variables) { { name: nil, completed: true, page: nil, perPage: nil } }

      it 'returns only completed todos' do
        subject
        expect(parsed_body.size).to eq(1)
        expect(parsed_body.first['completed']).to eq(true)
      end
    end

    context 'when filtering by name' do
      let(:variables) { { name: 'task1', completed: nil, page: nil, perPage: nil } }

      it 'returns todos matching the name' do
        subject
        expect(parsed_body.size).to eq(1)
        expect(parsed_body.first['name']).to eq('task1')
      end
    end

    context 'when paginating results' do
      let(:variables) { { name: nil, completed: nil, page: 1, perPage: 2 } }

      it 'returns the correct number of todos per page' do
        subject
        expect(parsed_body.size).to eq(2)
      end
    end
  end
end
