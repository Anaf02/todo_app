# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Todos::Update do
  subject(:contract) { described_class.new }

  it 'returns error if id is missing' do
    result = contract.call(name: "Task", completed: false)
    expect(result).to be_failure
    expect(result.errors.to_h).to include(id: ['is missing'])
  end

  it 'returns error if input is not valid' do
    result = contract.call(id: "Task", name: true, completed: 5)
    expect(result).to be_failure
    expect(result.errors.to_h).to include(id: ['must be an integer'])
    expect(result.errors.to_h).to include(name: ['must be a string'])
    expect(result.errors.to_h).to include(completed: ['must be boolean'])
  end

  it 'returns success if input is valid' do
    result = contract.call(id: 1, name: 'Task1', completed: false)
    expect(result).to be_success
  end
end
