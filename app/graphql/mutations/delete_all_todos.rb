# frozen_string_literal: true

module Mutations
  class DeleteAllTodos < BaseMutation
    description "Deletes all filtered todos (completed=true)"

    field :message, String, null: false

    argument :completed, Boolean, required: true

    def resolve(completed:)
      raise GraphQL::ExecutionError, "Only completed=true is allowed" unless completed

      result = Container["transactions.todos.delete_all"]
                 .call(transaction_input(Container["contracts.todos.delete_all"], completed: completed))

      Dry::Matcher::ResultMatcher.call(result) do |m|
        m.success(Integer) do |value|
          { message: "#{value} todo(s) have been deleted" }
        end

        m.failure do |error|
          raise GraphQL::ExecutionError.new "Error deleting all completed todos", extensions: error
        end
      end
    end
  end
end
