# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Operations::Create do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:todo) { create(:todo, name: "Task1") }
  subject(:operation) { described_class.new(todo_repository: todo_repository) }

  before do
    allow(todo_repository).to receive(:create).with(input).and_return(todo)
  end

  describe '#call' do
    context 'when input is correct' do
      let(:input) { { name: 'Task1', completed: false } }
      let(:todo) { create(:todo, name: "Task1") }

      before do
        allow(todo_repository).to receive(:create).with(input).and_return(todo)
      end

      it 'returns success with the todo' do
        result = operation.call(input)

        expect(result).to be_success
        expect(result.value!).to eq(todo)
      end
    end
  end
end
