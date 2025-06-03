# frozen_string_literal: true
require 'dry/transaction/operation'

module Operations
  module Todos
    class BaseOperation
      include Dry::Transaction::Operation
      include Import[:todo_repository]
    end
  end
end