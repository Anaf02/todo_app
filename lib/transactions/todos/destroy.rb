# frozen_string_literal: true

module Transactions
  module Todos
    class Destroy
      include Dry::Transaction(container: Container)
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate, with: "validate.todos.destroy"
      step :destroy_todo

      def destroy_todo(input)
        begin
          result = todo_repository.delete(input[:id])
          Success(result)
        rescue => e
          Failure({ message: e.message, status: :not_found })
        end
      end
    end
  end
end
