# frozen_string_literal: true

module Contracts
  module Todos
    class DeleteAll < Dry::Validation::Contract
      params do
        optional(:completed).maybe(:bool)
      end

      rule(:completed) do
        unless value.nil?
          key.failure("must be true") unless value == true
        end
      end
    end
  end
end
