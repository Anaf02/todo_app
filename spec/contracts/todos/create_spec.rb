# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Todos::Create do
  subject(:contract) { described_class.new }

  it 'returns error if name is missing' do
    result = contract.call(completed: false)
    expect(result).to be_failure
    expect(result.errors.to_h).to include(name: ['is missing'])
  end

  it 'returns success if input is valid' do
    result = contract.call(name: 'Task1', completed: false)
    expect(result).to be_success
  end
end
