# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    argument :name, String, required: true
    argument :completed, Boolean, required: false

    type Types::TodoType

    def resolve(name: nil, completed: false)
      Todo.create!(name: name, completed: completed)
    end
  end
end
