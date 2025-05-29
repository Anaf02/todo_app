# frozen_string_literal: true
require 'dry/transaction/operation'

module Operations
  class BaseTodoOperation
    include Dry::Transaction::Operation
    include Import[:todo_repository]
  end
end