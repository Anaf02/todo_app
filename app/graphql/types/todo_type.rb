# frozen_string_literal: true

module Types
  class TodoType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :completed, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
