# frozen_string_literal: true

module Operations
  module Todos
    class DeleteAll < BaseOperation

      def call(input)
        destroyed_count = todo_repository.delete_all(input)
        Success(destroyed_count)
      end
    end
  end
end