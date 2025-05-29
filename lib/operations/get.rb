# frozen_string_literal: true

module Operations
  class Get < BaseTodoOperation

  def call(input)
      todos = todo_repository.all(input) || []
      Success(todos)
    end
  end
end