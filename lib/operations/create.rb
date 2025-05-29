# frozen_string_literal: true

module Operations
  class Create < BaseTodoOperation

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
