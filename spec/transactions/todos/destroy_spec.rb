# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Todos::Destroy do
  let(:todo_repository) { instance_double('TodoRepository') }
  subject(:transaction) { described_class.new(todo_repository: todo_repository) }
  let(:input) { { id: 1 } }
  before do
    allow(todo_repository).to receive(:delete).with(input[:id]).and_return(true)
  end

  context 'when input is valid' do
    it 'returns success' do
      result = transaction.call(input)
      expect(result).to be_success
    end
  end

  context 'when input is invalid' do
    let(:input) { { id: "something" } }
    it 'returns failure' do
      result = transaction.call(input)
      expect(result).to be_failure
      expect(result.failure).to include(:id)
    end
  end
end
