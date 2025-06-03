# frozen_string_literal: true

module Operations
  module Todos
    class Get < BaseOperation

      def call(input)
        todos = todo_repository.all(input) || []
        Success(todos)
      end
    end
  end
end