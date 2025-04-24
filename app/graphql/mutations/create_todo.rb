# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    description "Creates todo with specified name and/or completed status"

    argument :name, String, required: true
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(name: nil, completed: false)
      todo = Todo.create(name: name, completed: completed)

      unless todo.save
        raise GraphQL::ExecutionError.new "Error creating todo", extensions: todo.errors.to_hash
      end
      todo
    end
  end
end
