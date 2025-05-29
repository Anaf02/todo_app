# frozen_string_literal: true

module Operations
  class DeleteAll < BaseTodoOperation

    def call(input)
      destroyed_count = todo_repository.delete_all(input)
      Success(destroyed_count)
    end
  end
end
