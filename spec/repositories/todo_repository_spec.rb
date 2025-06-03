# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoRepository, type: :model do
  let(:repository) { described_class.new }

  before(:each) do
    Todo.delete_all
  end

  describe "#create" do
    it "creates and persists a new todo to the database" do
      expect {
        todo = repository.create(name: "Task1", completed: false)
        expect(todo).to be_persisted
        expect(todo.name).to eq("Task1")
        expect(todo.completed).to eq(false)
      }.to change { Todo.count }.by(1)
    end
  end

  describe "#find" do
    it "finds a todo by id" do
      todo = create(:todo, name: "Task3")
      found_todo = repository.find(todo.id)

      expect(found_todo).to eq(todo)
    end

    it "raises ActiveRecord::RecordNotFound if id does not exist" do
      expect { repository.find(-1) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#all" do
    before do
      create(:todo, :completed, name: "Task1")
      create(:todo, name: "Task2")
    end

    it "returns all todos without filters" do
      results = repository.all({})

      expect(results.count).to eq(2)
    end

    it "filters todos by completed status" do
      results = repository.all({ completed: true })

      expect(results.count).to eq(1)
      expect(results.first.completed).to eq(true)
    end
  end

  describe "#update" do
    it "updates a todo's attributes" do
      todo = create(:todo, name: "Old task")

      repository.update(todo.id, { name: "New task", completed: true })

      todo.reload
      expect(todo.name).to eq("New task")
      expect(todo.completed).to eq(true)
    end
  end

  describe "#delete" do
    it "deletes a todo" do
      todo = create(:todo)

      expect { repository.delete(todo.id) }.to change { Todo.count }.by(-1)
    end
  end

  describe "#delete_all" do
    before do
      create(:todo, :completed)
      create(:todo)
    end

    it "deletes todos with filter for completed" do
      deleted_count = repository.delete_all({ completed: true })

      expect(deleted_count).to eq(1)
      expect(Todo.count).to eq(1)
    end

    it "deletes all todos without filters" do
      deleted_count = repository.delete_all({})

      expect(deleted_count).to eq(2)
      expect(Todo.count).to eq(0)
    end
  end
end
