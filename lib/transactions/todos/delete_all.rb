# frozen_string_literal: true

module Transactions
  module Todos
    class DeleteAll
      include Dry::Transaction(container: Container)
      include Dry::Monads[:result]
      include Import[:todo_repository]

      step :validate, with: "validate.todos.delete_all"
      step :delete_all_filtered

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
