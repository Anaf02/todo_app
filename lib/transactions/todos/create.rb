# frozen_string_literal: true

module Transactions
  module Todos
    class Create < BaseTransaction

      step :validate, with: "operations.validate"
      step :create_todo, with: "operations.todos.create"
    end
  end
end
