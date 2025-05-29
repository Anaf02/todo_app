# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::Get do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo_list) { double('TodoList') }
  subject(:operation) { described_class.new(todo_repository: todo_repository) }

  before do
    allow(todo_repository).to receive(:all).with(input).and_return(todo_list)
  end

  context 'when input is correct' do
    context 'with no parameters' do
      let(:input) { {} }

      it 'returns success' do
        result = operation.call(input)

        expect(result).to be_success
        expect(result.value!).to eq(todo_list)
      end
    end

    context 'with valid parameters' do
      let(:input) { { name: 'test', completed: false } }

      it 'returns success' do
        result = operation.call(input)

        expect(result).to be_success
        expect(result.value!).to eq(todo_list)
      end
    end
  end
end
