# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    description "Creates todo with specified name and/or completed status"

    argument :name, String, required: true
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(name: nil, completed: false)
      todo_manager = TodoManager.new
      result = todo_manager.create_todo({ name: name, completed: completed })

      if result.success?
        result.data
      else
        raise GraphQL::ExecutionError.new "Error creating todo", extensions: result.errors.to_hash
      end
    end
  end
end
