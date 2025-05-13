# frozen_string_literal: true
require_relative '../../contracts/todos/create_todo_contract'

module Transactions
  module Todos
    class Create
      include Dry::Transaction
      include Dry::Monads[:result]

      step :validate_params
      step :create_todo

      def validate_params(input)
        create_todo_contract = ::Contracts::Todos::CreateTodoContract.new

        result = create_todo_contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
        Success(input)
      end

      def create_todo(input)
        repository = Container.resolve(:todo_repository)

        todo = repository.build(input)
        if repository.save(todo)
          Success(todo)
        else
          Failure(todo.errors)
        end
      end
    end
  end
end