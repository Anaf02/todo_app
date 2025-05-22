# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Transactions::Todos::Create do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo) { create(:todo, name: "Task1") }
  subject(:transaction) { described_class.new(todo_repository: todo_repository) }

  before do
    allow(todo_repository).to receive(:create).with(input).and_return(todo)
  end

  describe '#call' do
    context 'when validation is successful' do
      let(:input) { { name: 'Task1', completed: false } }
      let(:validated_input) { input }
      let(:todo) { create(:todo, name: "Task1") }

      before do
        allow(transaction).to receive(:validate).and_return(Dry::Monads::Success(validated_input))
        allow(todo_repository).to receive(:create).with(validated_input).and_return(todo)
      end

      it 'returns success with the todo' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(todo)
      end
    end

    context 'when validation fails' do
      let(:input) { { completed: false } }
      let(:errors) { { name: ['is missing'] } }

      before do
        allow(transaction).to receive(:validate).and_return(Dry::Monads::Failure(errors))
      end

      it 'returns failure before creating todo' do
        result = transaction.call(input)

        expect(result).to be_failure
        expect(result.failure).to eq(errors)
        expect(todo_repository).not_to receive(:create)
      end
    end
  end
end
