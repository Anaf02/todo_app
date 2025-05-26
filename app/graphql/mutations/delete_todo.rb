# frozen_string_literal: true

module Mutations
  class DeleteTodo < BaseMutation
    description "Deletes a todo by ID"

    field :message, String, null: false

    argument :id, ID, required: true

    def resolve(id:)
      result = Container["todo_transactions.destroy"].call(id: id)

      Dry::Matcher::ResultMatcher.call(result) do |m|
        m.success do
          { message: "Todo deleted successfully" }
        end

        m.failure do |error|
          raise GraphQL::ExecutionError.new "Error deleting todo", extensions: error
        end
      end
    end
  end
end
