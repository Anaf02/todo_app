# frozen_string_literal: true

module Mutations
  class DeleteTodo < BaseMutation
    description "Deletes a todo by ID"

    field :message, String, null: false

    argument :id, ID, required: true

    def resolve(id:)
      result = Container["todo_transactions.destroy"].call(id: id)

      if result.success?
        { message: "Todo deleted successfully" }
      else
        raise GraphQL::ExecutionError.new "Error deleting todo", extensions: result.failure.to_hash
      end
    end
  end
end
