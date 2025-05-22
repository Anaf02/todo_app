# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Transactions::Todos::Create do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo) { create(:todo, name: "Task1") }

  before do
    allow(todo_repository).to receive(:create).with(input).and_return(todo)
  end

  context 'when input is valid' do
    subject(:transaction) { described_class.new(todo_repository: todo_repository) }
    let(:input) { { name: 'Task1', completed: false } }

    it 'returns success with the todo' do
      result = transaction.call(input)
      expect(result).to be_success
      expect(result.value!).to eq(todo)
    end
  end

  context 'when input is invalid' do
    let(:input) { { completed: false } }
    subject(:transaction) { described_class.new }

    it 'returns failure' do
      result = transaction.call(input)
      expect(result).to be_failure
      expect(result.failure).to include(:name)
    end
  end
end
