# frozen_string_literal: true

module Transactions
  module Todos
    class Get
      include Dry::Transaction
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate_params
      step :get_filtered_todos

      def validate_params(input)
        contract = ::Contracts::Todos::Get.new
        result = contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
      end

      def get_filtered_todos(input)
        todos = todo_repository.all(input) || []
        Success(todos)
      end
    end
  end
end
