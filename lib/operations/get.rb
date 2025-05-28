# frozen_string_literal: true

module Operations
  class Get
    include Dry::Monads[:result]

    def initialize(todo_repository)
      @todo_repository = todo_repository
    end

    def call(input)
      todos = @todo_repository.all(input) || []
      Success(todos)
    end
  end
end