# frozen_string_literal: true

module Operations
  class Destroy
    include Dry::Monads[:result]

    def initialize(todo_repository)
      @todo_repository = todo_repository
    end

    def call(input)
      begin
        result = @todo_repository.delete(input[:id])
        Success(result)
      rescue ActiveRecord::RecordNotFound => e
        Failure({ message: e.message, status: :not_found })
      end
    end
  end
end