# frozen_string_literal: true

module Transactions
  module Todos
    class Destroy < BaseTransaction

      step :validate, with: "contracts.todos.destroy"
      step :destroy_todo, with: "operations.todos.destroy"
    end
  end
end
