# frozen_string_literal: true

module Transactions
  module Todos
    class Get < BaseTransaction

      step :validate, with: "contracts.todos.get"
      step :get_filtered_todos, with: "operations.todos.get"
    end
  end
end
