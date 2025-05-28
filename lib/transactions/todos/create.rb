# frozen_string_literal: true

module Transactions
  module Todos
    class Create < BaseTransaction

      step :validate, with: "contracts.todos.create"
      step :create_todo, with: "operations.todos.create"
    end
  end
end
