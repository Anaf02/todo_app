# frozen_string_literal: true

module Transactions
  module Todos
    class DeleteAll
      include Dry::Transaction
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate_params
      step :delete_all_filtered

      def validate_params(input)
        contract = ::Contracts::Todos::DeleteAll.new
        result = contract.call(input)
        if result.success?
          Success(result.to_h)
        else
          Failure(result.errors.to_h)
        end
      end

      def delete_all_filtered(input)
        begin
          destroyed_count = todo_repository.delete_all(input)
          Success(destroyed_count)
        rescue => e
          Failure(e.message)
        end
      end
    end
  end
end
