# frozen_string_literal: true
require "dry/transaction/operation"

module Operations
  class Validate
    include Dry::Transaction::Operation

    def call(input)
      contract = input.delete(:contract)
      result = contract.call(input)
      if result.success?
        Success(result.to_h)
      else
        Failure(result.errors.to_h)
      end
    end
  end
end
