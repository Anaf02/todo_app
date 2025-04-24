# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateTodo do
  def update_query
    <<~GQL
      mutation UpdateTodo($id: ID!, $name: String, $completed: Boolean) {
        updateTodo(id: $id, name: $name, completed: $completed) {
          id
          name
          completed
        }
      }
    GQL
  end

  let(:new_todo) { { name: 'new task', completed: true } }

  describe '.resolve' do
    let!(:todo) { create(:todo, name: "old task") }

    it "updates both name and completed" do
      result = TodoAppSchema.execute(query: update_query,
                                     variables: {
                                       id: todo.id,
                                       name: new_todo[:name],
                                       completed: new_todo[:completed]
                                     })

      data = result['data']["updateTodo"]

      expect(data["name"]).to eq(new_todo[:name])
      expect(data["completed"]).to eq(new_todo[:completed])
    end

    it "updates only the name" do
      result = TodoAppSchema.execute(query: update_query,
                                     variables: {
                                       id: todo.id,
                                       name: new_todo[:name],
                                     })

      data = result['data']["updateTodo"]

      expect(data["name"]).to eq(new_todo[:name])
      expect(data["completed"]).to eq(todo[:completed])
    end

    it "updates only the completed status" do
      result = TodoAppSchema.execute(query: update_query,
                                     variables: {
                                       id: todo.id,
                                       completed: new_todo[:completed],
                                     })

      data = result['data']["updateTodo"]

      expect(data["name"]).to eq(todo[:name])
      expect(data["completed"]).to eq(new_todo[:completed])
    end
  end
end
