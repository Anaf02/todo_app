# frozen_string_literal: true

module Resolvers
  class TodosResolver < BaseResolver
    type Types::TodoResponseType, null: false
    description "Fetches todos with filters and metadata associated with them."

    argument :name, String, required: false
    argument :completed, Boolean, required: false

    def resolve(name: nil, completed: nil)
      filters = { name: name, completed: completed }.compact
      result = Container["todo_transactions.get"].call(filters)

      if result.success?
        {
          items: result.value!,
          metadata: build_metadata
        }
      else
        raise GraphQL::ExecutionError.new "Error fetching todos", extensions: result.failure.to_hash
      end
    end

    private

    def build_metadata
      active_todo_counter = ActiveTodoCounter.new
      {
        active: {
          count: active_todo_counter.count,
          formatted_message: active_todo_counter.message
        }
      }
    end
  end
end
