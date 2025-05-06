# frozen_string_literal: true
module Types
  class TodoResponseType < Types::BaseObject
    field :items, [Types::TodoType], null: false
    field :metadata, Types::TodosMetadataType, null: false
  end
end