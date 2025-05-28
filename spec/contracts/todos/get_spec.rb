# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Todos::Get do
  subject(:contract) { described_class.new }

  it 'returns error if input is invalid' do
    result = contract.call(name: true, completed: "Task")
    expect(result).to be_failure
    expect(result.errors.to_h).to include(name: ['must be a string'])
    expect(result.errors.to_h).to include(completed: ['must be boolean'])
  end

  it 'returns success if name is string and completed is boolean' do
    result = contract.call(name: "Task", completed: true)
    expect(result).to be_success
  end

  it 'returns success if no params are given' do
    result = contract.call({})
    expect(result).to be_success
  end
end
