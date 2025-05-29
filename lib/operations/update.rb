# frozen_string_literal: true

module Operations
  class Update < BaseTodoOperation

    def call(input)
      id = input[:id]
      attributes = input.reject { |v, _| v == :id }
      updated_todo = todo_repository.update(id, attributes)
      if updated_todo.present?
        Success(updated_todo)
      else
        Failure(:not_found)
      end
    end
  end
end
