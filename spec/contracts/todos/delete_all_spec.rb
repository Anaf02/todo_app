# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Todos::DeleteAll do
  subject(:contract) { described_class.new }

  it 'returns error if completed is false' do
    result = contract.call(completed: false)
    expect(result).to be_failure
    expect(result.errors.to_h).to include(completed: ['must be true'])
  end

  it 'returns error if completed is not boolean' do
    result = contract.call(completed: "string")
    expect(result).to be_failure
    expect(result.errors.to_h).to include(completed: ['must be boolean'])
  end

  it 'returns success if input is valid' do
    result = contract.call(completed: true)
    expect(result).to be_success
  end

  it 'returns success if input is valid' do
    result = contract.call({})
    expect(result).to be_success
  end
end