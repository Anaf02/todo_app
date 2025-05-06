# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :delete_all_todos, mutation: Mutations::DeleteAllTodos
    field :delete_todo, mutation: Mutations::DeleteTodo
    field :update_todo, mutation: Mutations::UpdateTodo
    field :create_todo, mutation: Mutations::CreateTodo

  end
end
