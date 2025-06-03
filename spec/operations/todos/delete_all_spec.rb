# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::Todos::DeleteAll do
  let(:todo_repository) { instance_double('TodoRepository') }
  let(:destroyed_count) { 5 }
  subject(:operation) { described_class.new(todo_repository: todo_repository) }

  describe '#call' do

    context 'when input is correct' do
      let(:input) { {} }
      before do
        allow(todo_repository).to receive(:delete_all).with(input).and_return(destroyed_count)
      end

      it 'returns success' do
        result = operation.call(input)

        expect(result).to be_success
        expect(result.value!).to eq(destroyed_count)
      end
    end
  end
end
