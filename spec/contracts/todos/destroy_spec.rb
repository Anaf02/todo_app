# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contracts::Todos::Destroy do
  subject(:contract) { described_class.new }

  it 'returns error if id is missing' do
    result = contract.call(name: "")
    expect(result).to be_failure
    expect(result.errors.to_h).to include(id: ['is missing'])
  end

  it 'returns success if input is valid' do
    result = contract.call(id: 1)
    expect(result).to be_success
  end
end
