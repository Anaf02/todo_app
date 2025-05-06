# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mutations::DeleteAllTodos', type: :request do
  def delete_all_query
    <<~GQL
      mutation DeleteAllTodos($completed: Boolean!) {
        deleteAllTodos(completed: $completed) {
          message
        }
      }
    GQL
  end

  let(:parsed_body) { JSON.parse(response.body)['data']['deleteAllTodos'] }
  let(:parsed_errors) { JSON.parse(response.body)['errors'] }

  describe '.resolve' do
    before do
      Todo.delete_all
      create_list(:todo, 10)
    end

    subject { post '/graphql', params: params, as: :json }
    let(:params) { { query: delete_all_query, variables: { completed: true } } }

    context 'when completed todos exist' do
      before do
        create_list(:todo, 20, :completed)
      end

      it 'deletes all completed todos' do
        expect { subject
        }.to change { Todo.count }.by(-20)

        expect(parsed_body['message']).to eq("20 todo(s) have been deleted")
      end

      context 'when the completed parameter passed is false' do
        let(:params) { { query: delete_all_query, variables: { completed: false } } }

        it 'does not delete anything and returns an error message' do
          expect { subject
          }.to change { Todo.count }.by(0)

          expect(parsed_errors.first['message']).to eq("Only completed=true is allowed")
        end
      end
    end

    context 'when no completed todos exist' do
      it 'does not delete anything' do
        expect { subject
        }.to change { Todo.count }.by(0)

        expect(parsed_body['message']).to eq("0 todo(s) have been deleted")
      end
    end
  end
end