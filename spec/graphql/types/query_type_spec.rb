# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Query Type', type: :request do
  def todos_query
    <<~GQL
      query Todos($name: String, $completed: Boolean, $first: Int, $last: Int, $after: String, $before: String) {
        todos(name: $name, completed: $completed) {
          metadata {
            active {
              count
              formattedMessage
            }
          }
          items(first: $first, last: $last, after: $after, before: $before){
            edges {
              node {
                id
                name
                completed
              }
            }
            pageInfo {
              endCursor
              hasNextPage
            }
          }
        }
      }
    GQL
  end

  def parsed_body
    JSON.parse(response.body)['data']
  end

  def parsed_edges
    parsed_body['todos']['items']['edges']
  end

  def parsed_todo_nodes
    parsed_edges.map { |edge| edge['node'] }
  end

  def parsed_metadata
    parsed_body['todos']['metadata']
  end

  def parsed_errors
    JSON.parse(response.body)['errors']
  end

  def parsed_has_next_page
    parsed_body['todos']['items']['pageInfo']['hasNextPage']
  end

  let(:cursor) { parsed_body['todos']['items']['pageInfo']['endCursor'] }

  describe 'todos query' do
    before(:each) do
      Todo.delete_all
      create(:todo, name: 'task1')
      create(:todo, :completed, name: 'task2')
      create(:todo, name: 'task3')
    end

    after(:each) do
      if parsed_errors
        puts "GraphQL Errors: #{parsed_errors.first['message']}"
      end
    end

    subject { post '/graphql', params: params, as: :json }
    let(:params) { { query: todos_query, variables: variables } }

    context 'when no filters are applied' do
      let(:variables) { { name: nil, completed: nil, first: nil, last: nil, after: nil, before: nil } }

      it 'returns all todos and metadata' do
        subject

        expect(parsed_todo_nodes.size).to eq(3)
        expect(parsed_todo_nodes.first['name']).to eq('task1')
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when filtering by completed status' do
      let(:variables) { { name: nil, completed: true, first: nil, last: nil, after: nil, before: nil } }

      it 'returns only completed todos and metadata' do
        subject

        expect(parsed_todo_nodes.size).to eq(1)
        expect(parsed_todo_nodes.first['completed']).to eq(true)
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when filtering by name' do
      let(:variables) { { name: 'task1', completed: nil, first: nil, last: nil, after: nil, before: nil } }

      it 'returns todos matching the name and metadata' do
        subject

        expect(parsed_todo_nodes.size).to eq(1)
        expect(parsed_todo_nodes.first['name']).to eq('task1')
        expect(parsed_metadata['active']['count']).to eq(2)
        expect(parsed_metadata['active']['formattedMessage']).to eq("2 items left!")
      end
    end

    context 'when paginating results with different options' do
      let(:variables) { { name: nil, completed: nil, first: 2, last: nil, after: nil, before: nil } }

      it 'fetches first 2 items and cursor, then last 1 before that cursor, then first 1 after the cursor' do
        subject

        expect(parsed_todo_nodes.size).to eq(2)
        expect(cursor).to be_present

        expect(parsed_todo_nodes.first['name']).to eq('task1')
        expect(parsed_todo_nodes.first['completed']).to eq(false)
        expect(parsed_todo_nodes.second['name']).to eq('task2')
        expect(parsed_todo_nodes.second['completed']).to eq(true)
        expect(parsed_has_next_page).to eq(true)

        post '/graphql', params: { query: todos_query, variables: { name: nil, completed: nil, first: nil, last: 1, after: nil, before: cursor } }, as: :json

        expect(parsed_todo_nodes.size).to eq(1)
        expect(parsed_todo_nodes.first['name']).to eq('task1')
        expect(parsed_todo_nodes.first['completed']).to eq(false)
        expect(parsed_has_next_page).to eq(true)

        post '/graphql', params: { query: todos_query, variables: { name: nil, completed: nil, first: 1, last: nil, after: cursor, before: nil } }, as: :json

        expect(parsed_todo_nodes.size).to eq(1)
        expect(parsed_todo_nodes.first['name']).to eq('task3')
        expect(parsed_todo_nodes.first['completed']).to eq(false)
        expect(parsed_has_next_page).to eq(false)
      end
    end
  end
end