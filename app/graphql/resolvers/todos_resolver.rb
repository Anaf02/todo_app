# frozen_string_literal: true

module Resolvers
  class TodosResolver < BaseResolver
    type Types::TodoResponseType, null: false
    description "Fetches todos with filters and metadata associated with them."

    argument :name, String, required: false
    argument :completed, Boolean, required: false
    argument :page, Integer, required: false
    argument :perPage, Integer, required: false

    def resolve(name: nil, completed: nil, page: nil, perPage: nil)
      todo_manager = TodoManager.new
      filters = { name: name, completed: completed }.compact
      result = todo_manager.get_all_todos(filters, page, perPage)

      if result.success?
        {
          items: result.data,
          metadata: build_metadata
        }
      else
        raise GraphQL::ExecutionError.new "Error fetching todos", extensions: result.errors.to_hash
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
