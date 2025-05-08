# frozen_string_literal: true

require 'rails_helper'
require 'base64'

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

  let(:parsed_body) { JSON.parse(response.body)['data'] }
  let(:parsed_todo_nodes) { parsed_body['todos']['items']['edges'].map { |edge| edge['node'] } }
  let(:parsed_metadata) { parsed_body['todos']['metadata'] }
  let(:parsed_has_next_page) { parsed_body['todos']['items']['pageInfo']['hasNextPage'] }
  let(:end_cursor_after_second_todo) { Base64.strict_encode64("2") }

  describe 'todos query' do
    before do
      Todo.delete_all
    end

    let!(:todo1) { create(:todo, name: 'task1') }
    let!(:todo2) { create(:todo, :completed, name: 'task2') }
    let!(:todo3) { create(:todo, name: 'task3') }

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
      context 'when using first parameter' do
        let(:variables) { { name: nil, completed: nil, first: 2, last: nil, after: nil, before: nil } }

        it 'fetches first 2 items' do
          subject

          expect(parsed_todo_nodes.size).to eq(2)
          expect(parsed_todo_nodes.first['name']).to eq('task1')
          expect(parsed_todo_nodes.first['completed']).to eq(false)
          expect(parsed_todo_nodes.second['name']).to eq('task2')
          expect(parsed_todo_nodes.second['completed']).to eq(true)
          expect(parsed_has_next_page).to eq(true)
        end

        context 'when using first and after parameters' do
          let(:variables) { { name: nil, completed: nil, first: 1, last: nil, after: end_cursor_after_second_todo, before: nil } }

          it 'fetches first item after the cursor' do
            subject

            expect(parsed_todo_nodes.size).to eq(1)
            expect(parsed_todo_nodes.first['name']).to eq('task3')
            expect(parsed_todo_nodes.first['completed']).to eq(false)
            expect(parsed_has_next_page).to eq(false)
          end
        end
      end

      context 'when using last and before parameters' do
        let(:variables) { { name: nil, completed: nil, first: nil, last: 1, after: nil, before: end_cursor_after_second_todo } }

        it 'fetches last 2 items before a given cursor' do
          subject

          expect(parsed_todo_nodes.size).to eq(1)
          expect(parsed_todo_nodes.first['name']).to eq('task1')
          expect(parsed_todo_nodes.first['completed']).to eq(false)
          expect(parsed_has_next_page).to eq(true)
        end
      end
    end
  end
end