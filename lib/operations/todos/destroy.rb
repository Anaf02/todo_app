# frozen_string_literal: true

module Operations
  module Todos
    class Destroy < BaseOperation

      def call(input)
        begin
          result = todo_repository.delete(input[:id])
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Failure({ message: e.message, status: :not_found })
        end
      end
    end
  end
end
