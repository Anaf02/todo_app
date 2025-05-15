# frozen_string_literal: true
require_relative '../../contracts/todos/create_todo_contract'

module Transactions
  module Todos
    class Create
      include Dry::Transaction
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate_params
      step :create_todo

      def validate_params(input)
        contract = ::Contracts::Todos::CreateTodoContract.new
        result = contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
      end

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
