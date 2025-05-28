# frozen_string_literal: true
require 'dry/transaction/operation'

module Operations
  class Create
    include Dry::Transaction::Operation
    include Import[:todo_repository]

    def call(input)
      todo = todo_repository.create(input)
      if todo.persisted?
        Success(todo)
      else
        Failure(todo.errors)
      end
    end
  end
end
