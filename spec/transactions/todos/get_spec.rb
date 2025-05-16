# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Todos::Get do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo_list) { double('TodoList') }
  subject(:transaction) { described_class.new(todo_repository: todo_repository) }

  before do
    allow(todo_repository).to receive(:all).with(input).and_return(todo_list)
  end

  context 'with valid input' do
    context 'with no parameters' do
      let(:input) { {} }
      it 'returns success' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(todo_list)
      end
    end

    context 'with parameters' do
      let(:input) { { name: 'test', completed: false } }
      it 'returns success' do
        result = transaction.call(input)
        expect(result).to be_success
        expect(result.value!).to eq(todo_list)
      end
    end
  end

  context 'with invalid input' do
    context 'with name not a string' do
      let(:input) { { name: true } }
      it 'returns failure' do
        result = transaction.call(input)
        expect(result).to be_failure
        expect(result.failure).to include(:name)
      end
    end

    context 'with completed not boolean' do
      let(:input) { { completed: "string" } }
      it 'returns failure' do
        result = transaction.call(input)
        expect(result).to be_failure
        expect(result.failure).to include(:completed)
      end
    end
  end
end
