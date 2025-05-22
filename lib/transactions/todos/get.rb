# frozen_string_literal: true

module Transactions
  module Todos
    class Get
      include Dry::Transaction(container: Container)
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate, with: "validate.todos.get"
      step :get_filtered_todos

      def get_filtered_todos(input)
        begin
          todos = todo_repository.all(input) || []
          Success(todos)
        rescue => e
          Failure(e.message)
        end
      end
    end
  end
end
