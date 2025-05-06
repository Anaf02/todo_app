# frozen_string_literal: true

module Mutations
  class DeleteAllTodos < BaseMutation
    description "Deletes all filtered todos (completed=true)"

    field :message, String, null: false

    argument :completed, Boolean, required: true

    def resolve(completed:)
      raise GraphQL::ExecutionError, "Only completed=true is allowed" unless completed

      todo_manager = TodoManager.new
      result = todo_manager.destroy_all(completed: completed)

      if result.success?
        { message: "#{result.data} todo(s) have been deleted" }
      else
        raise GraphQL::ExecutionError.new "Error deleting all completed todos", extensions: result.errors.to_hash
      end
    end
  end
end
