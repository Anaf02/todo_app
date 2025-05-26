# frozen_string_literal: true

module Mutations
  class UpdateTodo < BaseMutation
    description "Updates todo by id"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(id:, name: nil, completed: nil)
      attributes = {}
      attributes[:name] = name unless name.nil?
      attributes[:completed] = completed unless completed.nil?
      input_hash = attributes.merge(id: id.to_i)

      result = Container["todo_transactions.update"].call(input_hash)
      if result.success?
        result.value!
      else
        raise GraphQL::ExecutionError.new("Error updating todo", extensions: result.failure.to_hash)
      end
    end
  end
end
