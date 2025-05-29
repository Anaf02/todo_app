# frozen_string_literal: true

module Transactions
  module Todos
    class Update < BaseTransaction

      step :validate, with: "contracts.todos.update"
      step :update_todo, with: "operations.todos.update"
    end
  end
end
