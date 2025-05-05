# frozen_string_literal: true

module Types
  class TodosMetadataType < Types::BaseObject
    field :active, Types::ActiveMetadataType, null: false
  end
end