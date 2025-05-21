# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mutations::DeleteTodo', type: :request do
  def delete_query
    <<~GQL
      mutation DeleteTodo($id: ID!) {
        deleteTodo(id: $id) {
          message
        }
      }
    GQL
  end

  let(:parsed_body) { JSON.parse(response.body)['data']['deleteTodo'] }
  let(:parsed_errors) { JSON.parse(response.body)['errors'] }

  describe '.resolve' do
    subject { post '/graphql', params: params, as: :json }
    before(:each) do
      Todo.delete_all
    end

    context 'when todo exists' do
      let(:todo) { create(:todo, name: "task") }
      let(:params) { { query: delete_query, variables: { id: todo.id } } }
      it 'succeeds and returns deletion message' do
        subject

        expect(parsed_body['message']).to eq("Todo deleted successfully")
      end
    end

    context "when todo doesn't exist" do
      let(:params) { { query: delete_query, variables: { id: -1 } } }

      it 'fails and returns deletion error message' do
        subject

        expect(parsed_errors.first['message']).to eq("Error deleting todo")

        expect(parsed_errors.first['extensions']).to eq(
                                                       'message' => "Couldn't find Todo with 'id'=-1",
                                                       'status' => 'not_found'
                                                     )
      end
    end
  end
end
