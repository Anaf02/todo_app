# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::Todos::Destroy do
  let(:todo_repository) { instance_double('TodoRepository') }
  subject(:operation) { described_class.new(todo_repository: todo_repository) }
  let(:input) { { id: 1 } }
  before do
    allow(todo_repository).to receive(:delete).with(input[:id]).and_return(true)
  end

  context 'when input is correct' do
    it 'returns success' do
      result = operation.call(input)
      expect(result).to be_success
    end
  end
end
