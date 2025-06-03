# frozen_string_literal: true

module Contracts
  module Todos
    class Destroy < Dry::Validation::Contract
      params do
        required(:id).filled(:integer)
      end
    end
  end
end
