# frozen_string_literal: true
require 'spec_helper'

RSpec.describe TodoManager do
  let(:repository) { instance_double(TodoRepository) }
  let(:manager) { described_class.new(repository) }
  let(:todo) { double('Todo', errors: ['Error']) }
  let(:todo_list) { double('TodoList') }

  describe '#create_todo' do
    let(:params) { { name: 'Todo' } }

    it 'returns success when todo is saved' do
      allow(repository).to receive(:build).with(params).and_return(todo)
      allow(repository).to receive(:save).with(todo).and_return(true)

      result = manager.create_todo(params)

      expect(result.success?).to be true
      expect(result.todo).to eq(todo)
    end

    it 'returns errors when todo is not saved' do
      allow(repository).to receive(:build).with(params).and_return(todo)
      allow(repository).to receive(:save).with(todo).and_return(false)

      result = manager.create_todo(params)

      expect(result.success?).to be false
      expect(result.errors).to eq(todo.errors)
    end
  end

  describe '#get_all_todos' do
    let(:filtering_params) { { completed: false, name: "Task" } }
    let(:pagination) { { page: TodoManager::DEFAULT_PAGE, per_page: TodoManager::DEFAULT_PER_PAGE } }

    it 'returns success when todos are found' do
      paginated_todos = double('PaginatedTodos')
      allow(repository).to receive(:all).with(filtering_params).and_return(todo_list)
      allow(todo_list).to receive(:page).with(pagination[:page]).and_return(todo_list)
      allow(todo_list).to receive(:per).with(pagination[:per_page]).and_return(paginated_todos)
      allow(paginated_todos).to receive(:present?).and_return(true)

      result = manager.get_all_todos(filtering_params, pagination[:page], pagination[:per_page])

      expect(result.success?).to be true
      expect(result.todo).to eq(paginated_todos)
    end

    it 'returns error when no todos are found' do
      allow(repository).to receive(:all).with(filtering_params).and_return(todo_list)
      allow(todo_list).to receive(:page).and_return(todo_list)
      allow(todo_list).to receive(:per).and_return(nil)

      result = manager.get_all_todos(filtering_params, pagination[:page], pagination[:per_page])

      expect(result.success?).to be false
      expect(result.errors).to eq('No todos found')
    end
  end

  describe '#update_todo' do
    let(:id) { 1 }
    let(:params) { { name: 'Updated Todo' } }

    it 'returns success when todo is updated' do
      allow(repository).to receive(:find).with(id).and_return(todo)
      allow(repository).to receive(:update).with(id, params).and_return(true)

      result = manager.update_todo(id, params)

      expect(result.success?).to be true
      expect(result.todo).to eq(todo)
    end

    it 'returns error when todo not found' do
      allow(repository).to receive(:find).with(id).and_return(nil)

      result = manager.update_todo(id, params)

      expect(result.success?).to be false
      expect(result.errors).to eq('Todo not found')
    end

    it 'returns error when update fails' do
      allow(repository).to receive(:find).with(id).and_return(todo)
      allow(repository).to receive(:update).with(id, params).and_return(false)

      result = manager.update_todo(id, params)

      expect(result.success?).to be false
      expect(result.errors).to eq(todo.errors)
    end
  end

  describe '#destroy_todo' do
    let(:id) { 1 }

    it 'returns success when todo is destroyed' do
      allow(repository).to receive(:find).with(id).and_return(todo)
      allow(repository).to receive(:delete).with(id).and_return(true)

      result = manager.destroy_todo(id)

      expect(result.success?).to be true
    end

    it 'returns error when todo not found' do
      allow(repository).to receive(:find).with(id).and_return(nil)

      result = manager.destroy_todo(id)

      expect(result.success?).to be false
      expect(result.errors).to eq('Todo not found')
    end

    it 'returns error when delete fails' do
      allow(repository).to receive(:find).with(id).and_return(todo)
      allow(repository).to receive(:delete).with(id).and_return(false)

      result = manager.destroy_todo(id)

      expect(result.success?).to be false
      expect(result.errors).to eq(todo.errors)
    end
  end

  describe '#destroy_all_completed_todos' do
    let(:filter_params) { { completed: true } }

    it 'returns success with destroyed count' do
      allow(repository).to receive(:delete_all).with(filter_params).and_return(5)

      result = manager.destroy_all_completed_todos(filter_params)

      expect(result.success?).to be true
      expect(result.todo).to eq(5)
    end
  end
end
