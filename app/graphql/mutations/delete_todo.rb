# frozen_string_literal: true

module Mutations
  class DeleteTodo < BaseMutation
    description "Deletes a todo by ID"

    field :message, String, null: false

    argument :id, ID, required: true

    def resolve(id:)
      todo_manager = TodoManager.new
      result = todo_manager.destroy_todo(id)

      if result.success?
        { message: "Todo deleted successfully" }
      else
        raise GraphQL::ExecutionError.new "Error deleting todo", extensions: result.errors.to_hash
      end
    end
  end
end
