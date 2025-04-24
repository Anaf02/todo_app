# frozen_string_literal: true

module Mutations
  class UpdateTodo < BaseMutation
    description "Updates todo by id"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(id:, name: nil, completed: nil)
      todo = ::Todo.find(id)

      attributes = {}
      attributes[:name] = name unless name.nil?
      attributes[:completed] = completed unless completed.nil?

      unless todo.update(attributes)
        raise GraphQL::ExecutionError.new("Error updating todo", extensions: todo.errors.to_hash)
      end

      todo
    end
  end
end
