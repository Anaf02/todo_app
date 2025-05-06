# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Query Type', type: :request do
  def todos_query
    <<~GQL
      query Todos($name: String, $completed: Boolean, $page: Int, $perPage: Int) {
        todos(name: $name, completed: $completed, page: $page, perPage: $perPage) {
            items {
              id
              name
              completed
          }
            metadata {
              active {
                count
                formattedMessage
            }
          }
        }
      }
    GQL
  end

  let(:parsed_body) { JSON.parse(response.body)['data'] }
  let(:parsed_todos) { parsed_body['todos']['items'] }
  let(:parsed_metadata) { parsed_body['todos']['metadata'] }

  describe 'todos query' do
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

      it 'returns all todos and metadata' do
        subject

        expect(parsed_todos.size).to eq(3)
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when filtering by completed status' do
      let(:variables) { { name: nil, completed: true, page: nil, perPage: nil } }

      it 'returns only completed todos and metadata' do
        subject

        expect(parsed_todos.size).to eq(1)
        expect(parsed_todos.first['completed']).to eq(true)
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when filtering by name' do
      let(:variables) { { name: 'task1', completed: nil, page: nil, perPage: nil } }

      it 'returns todos matching the name and metadata' do
        subject

        expect(parsed_todos.size).to eq(1)
        expect(parsed_todos.first['name']).to eq('task1')
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when paginating results' do
      let(:variables) { { name: nil, completed: nil, page: 1, perPage: 2 } }

      it 'returns the correct number of todos per page and metadata' do
        subject

        expect(parsed_todos.size).to eq(2)
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end
  end
end
