# frozen_string_literal: true

module Contracts
  module Todos
    class Get < Dry::Validation::Contract
      params do
        optional(:name).filled(:string)
        optional(:completed).filled(:bool)
      end
    end
  end
end
