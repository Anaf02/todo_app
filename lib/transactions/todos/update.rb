# frozen_string_literal: true

module Transactions
  module Todos
    class Update
      include Dry::Transaction
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate_params
      step :update_todo

      def validate_params(input)
        contract = ::Contracts::Todos::Update.new
        result = contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
      end

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
