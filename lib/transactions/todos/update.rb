# frozen_string_literal: true

module Transactions
  module Todos
    class Update < BaseTransaction

      step :validate, with: "operations.validate"
      step :update_todo, with: "operations.todos.update"
    end
  end
end
