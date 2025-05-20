# frozen_string_literal: true

module Contracts
  module Todos
    class Update < Dry::Validation::Contract
      params do
        required(:id).filled(:integer)
        optional(:name).filled(:string)
        optional(:completed).filled(:bool)
      end
    end
  end
end
