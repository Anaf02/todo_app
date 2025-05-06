# frozen_string_literal: true

module Types
  class ActiveMetadataType < Types::BaseObject
    field :count, Integer, null: false
    field :formatted_message, String, null: false
  end
end

