# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::DeleteAll do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:destroyed_count) { 5 }
  subject(:transaction) { described_class.new }

  describe '#call' do
    context 'when validation is successful' do
      let(:input) { {} }

      before do
        allow(transaction).to receive(:validate).and_return(Dry::Monads::Success(input))
        allow(todo_repository).to receive(:delete_all).with(input).and_return(destroyed_count)
      end

      it 'returns success' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(destroyed_count)
      end
    end

    context 'when validation fails' do
      let(:input) { { completed: false } }
      let(:errors) { { name: ['is missing'] } }

      before do
        allow(transaction).to receive(:validate).and_return(Dry::Monads::Failure(input))
      end

      it 'returns failure' do
        result = transaction.call(input)
        expect(result).to be_failure
        expect(result.failure).to include(:completed)
        expect(todo_repository).not_to receive(:delete_all)
      end
    end
  end
end
