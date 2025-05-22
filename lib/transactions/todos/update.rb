# frozen_string_literal: true

module Transactions
  module Todos
    class Update
      include Dry::Transaction(container: Container)
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate, with: "validate.todos.update"
      step :update_todo

      def update_todo(input)
        id = input[:id]
        attributes = input.reject { |v, _| v == :id }
        updated_todo = todo_repository.update(id, attributes)
        if updated_todo.present?
          Success(updated_todo)
        else
          Failure(:not_found)
        end
      end
    end
  end
end
