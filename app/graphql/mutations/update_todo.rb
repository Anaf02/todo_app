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

      Dry::Matcher::ResultMatcher.call(result) do |m|
        m.success do |value|
          value
        end
        m.failure do |error|
          raise GraphQL::ExecutionError.new("Error updating todo", extensions: error)
        end
      end
    end
  end
end
