# frozen_string_literal: true

module Resolvers
  class TodosResolver < BaseResolver
    type [Types::TodoType], null: false
    description "Fetches todos with filters"

    argument :name, String, required: false
    argument :completed, Boolean, required: false
    argument :page, Integer, required: false
    argument :perPage, Integer, required: false

    def resolve(name: nil, completed: nil, page: nil, perPage: nil)
      todo_manager = TodoManager.new
      filters = { name: name, completed: completed }.compact
      result = todo_manager.get_all_todos(filters, page, perPage)

      if result.success?
        result.todo
      else
        raise GraphQL::ExecutionError.new "Error fetching todos", extensions: result.errors.to_hash
      end
    end
  end
end
