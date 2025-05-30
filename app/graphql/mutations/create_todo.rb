# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    description "Creates todo with specified name and/or completed status"

    argument :name, String, required: true
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(name: nil, completed: false)
      result = Container["transactions.todos.create"]
                 .call(transaction_input(Container["contracts.todos.create"], { name: name, completed: completed }))

      Dry::Transaction::ResultMatcher.call(result) do |m|
        m.success do |value|
          value
        end

        m.failure do |error|
          raise GraphQL::ExecutionError.new "Error creating todo", extensions: error
        end
      end
    end
  end
end
