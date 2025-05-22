# frozen_string_literal: true

module Steps
  class Validate
    include Dry::Monads[:result]

    def initialize(contract)
      @contract = contract
    end

    def call(input)
      result = @contract.call(input)
      if result.success?
        Success(result.to_h)
      else
        Failure(result.errors.to_h)
      end
    end
  end
end
