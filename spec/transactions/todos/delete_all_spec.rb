# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Todos::DeleteAll do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:destroyed_count) { 5 }
  subject(:transaction) { described_class.new(todo_repository: todo_repository) }

  before do
    allow(todo_repository).to receive(:delete_all).with(input).and_return(destroyed_count)
  end

  context 'when input is valid' do
    context 'without filters' do
      let(:input) { {} }
      it 'returns success' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(destroyed_count)
      end
    end

    context 'with completed=true filter' do
      let(:input) { { completed: true } }
      it 'returns success' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(destroyed_count)
      end
    end
  end

  context 'when input is invalid' do
    context 'with completed = false' do
      let(:input) { { completed: false } }
      it 'returns failure' do
        result = transaction.call(input)
        expect(result).to be_failure
        expect(result.failure).to include(:completed)
      end
    end

    context 'with completed = string' do
      let(:input) { { completed: 'some string' } }
      it 'returns failure' do
        result = transaction.call(input)
        expect(result).to be_failure
        expect(result.failure).to include(:completed)
      end
    end
  end
end
