# frozen_string_literal: true

module Transactions
  module Todos
    class Destroy
      include Dry::Transaction
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate_params
      step :destroy_todo

      def validate_params(input)
        contract = ::Contracts::Todos::Destroy.new
        result = contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
      end

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
