# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Todos::Update do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo) { create(:todo, name: "Task1") }

  context 'when todo exists' do
    before do
      allow(todo_repository).to receive(:update).with(todo.id, { name: todo.name, completed: todo.completed }).and_return(todo)
    end

    subject(:transaction) { described_class.new(todo_repository: todo_repository) }

    context 'with valid input' do
      let(:input) { { id: todo.id, name: todo.name, completed: todo.completed } }

      it 'returns success with the updated todo' do
        result = transaction.call(input)

        expect(result).to be_success
        expect(result.value!).to eq(todo)
      end
    end

    context 'with invalid input' do
      let(:input) { { id: todo.id, name: todo.completed, completed: todo.name } }

      it 'returns failure' do
        result = transaction.call(input)

        expect(result).to be_failure
        expect(result.failure).to include(:name, :completed)
      end
    end
  end

  context 'when todo does not exist' do
    subject(:transaction) { described_class.new(todo_repository: todo_repository) }
    let(:input) { { id: todo.id, name: todo.name, completed: todo.completed } }
    
    before do
      allow(todo_repository).to receive(:update).with(todo.id, { name: todo.name, completed: todo.completed }).and_return(false)
    end
    
    it 'returns failure' do
      result = transaction.call(input)

      expect(result).to be_failure
      expect(result.failure).to eq(:not_found)
    end
  end
end
