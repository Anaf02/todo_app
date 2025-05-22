# frozen_string_literal: true

module Transactions
  module Todos
    class Create
      include Dry::Transaction(container: Container)
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate, with: "validate.todos.create"
      step :create_todo

      def create_todo(input)
        todo = todo_repository.build(input)
        if todo_repository.save(todo)
          Success(todo)
        else
          Failure(todo.errors)
        end
      end
    end
  end
end
