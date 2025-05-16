# frozen_string_literal: true
module Contracts
  module Todos
    class CreateTodoContract < Dry::Validation::Contract
      params do
        required(:name).filled(:string)
        optional(:completed).filled(:bool)
      end
    end
  end
end