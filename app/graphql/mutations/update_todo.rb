# frozen_string_literal: true

module Mutations
  class UpdateTodo < BaseMutation
    description "Updates todo by id"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(id:, name: nil, completed: nil)
      result = Container["transactions.todos.update"]
                 .call(transaction_input(Container["contracts.todos.update"], update_params(id: id, name: name, completed: completed)))

      Dry::Matcher::ResultMatcher.call(result) do |m|
        m.success do |value|
          value
        end
        m.failure do |error|
          raise GraphQL::ExecutionError.new("Error updating todo", extensions: error)
        end
      end
    end

    private

    def update_params(id:, name: nil, completed: nil)
      {
        id: id.to_i,
        name: name,
        completed: completed
      }.compact
    end
  end
end
