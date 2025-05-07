# frozen_string_literal: true
module Types
  class TodoResponseType < Types::BaseObject
    field :items, Types::TodoType.connection_type, null: false
    field :metadata, Types::TodosMetadataType, null: false
  end
end