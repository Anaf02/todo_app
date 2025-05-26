# frozen_string_literal: true

module Mutations
  class DeleteAllTodos < BaseMutation
    description "Deletes all filtered todos (completed=true)"

    field :message, String, null: false

    argument :completed, Boolean, required: true

    def resolve(completed:)
      raise GraphQL::ExecutionError, "Only completed=true is allowed" unless completed

      result = Container["todo_transactions.delete_all"].call(completed: completed)

      if result.success?
        { message: "#{result.value!} todo(s) have been deleted" }
      else
        raise GraphQL::ExecutionError.new "Error deleting all completed todos", extensions: result.failure.to_hash
      end
    end
  end
end
