# frozen_string_literal: true

module Transactions
  module Todos
    class DeleteAll < BaseTransaction

      step :validate, with: "operations.validate"
      step :delete_all_filtered, with: "operations.todos.delete_all"
    end
  end
end
