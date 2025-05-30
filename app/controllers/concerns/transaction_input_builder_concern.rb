# frozen_string_literal: true

module TransactionInputBuilderConcern
  extend ActiveSupport::Concern

  def transaction_input(contract, params)
    {
      contract: contract
    }.merge(params.to_h)
  end

end
