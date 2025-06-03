# frozen_string_literal: true
module Transactions
  module Todos
    class BaseTransaction
      include Dry::Transaction(container: Container)
    end
  end
end
