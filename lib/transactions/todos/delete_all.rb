# frozen_string_literal: true

module Transactions
  module Todos
    class DeleteAll < BaseTransaction

      step :validate, with: "contracts.todos.delete_all"
      step :delete_all_filtered, with: "operations.todos.delete_all"
    end
  end
end
