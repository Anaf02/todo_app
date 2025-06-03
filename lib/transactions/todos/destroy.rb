# frozen_string_literal: true

module Transactions
  module Todos
    class Destroy < BaseTransaction

      step :validate, with: "operations.validate"
      step :destroy_todo, with: "operations.todos.destroy"
    end
  end
end
