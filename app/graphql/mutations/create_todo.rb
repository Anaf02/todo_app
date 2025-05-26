# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    description "Creates todo with specified name and/or completed status"

    argument :name, String, required: true
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(name: nil, completed: false)
      result = Container["todo_transactions.create"].call({ name: name, completed: completed })

      if result.success?
        result.value!
      else
        raise GraphQL::ExecutionError.new "Error creating todo", extensions: result.errors.to_hash
      end
    end
  end
end
