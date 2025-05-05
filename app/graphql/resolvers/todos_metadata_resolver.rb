# frozen_string_literal: true\

module Resolvers
  class TodosMetadataResolver < BaseResolver
    type Types::TodosMetadataType, null: false
    description "Fetches metadata related to the current todos"

    def resolve
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