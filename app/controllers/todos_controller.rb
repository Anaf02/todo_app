# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    todo = Todo.create(todo_params)
    if todo.persisted?
      render json: todo, status: :created
    else
      render json: { error: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @todos = Todo.all
    active_todo_counter = ActiveTodoCounter.new
    active_count = active_todo_counter.count(@todos)

    render json: {
      todos: @todos,
      metadata: {
        active: {
          count: active_count,
          formatted_message: active_todo_counter.message
        }
      }
    }
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo.update(todo_params)
      render json: @todo, status: :ok
    else
      render json: { error: @todo.errors.full_messages }, status: :not_found
    end
  end

  def delete_all
    @todos = Todo.destroy_all
    render json: { message: "All todos have been deleted" }, status: :ok
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render json: { message: "Todo deleted" }, status: :ok
  end

  def active_todos_count
    active_todo_counter = ActiveTodoCounter.new
    @active_todos = active_todo_counter.count(Todo.all)
    render json: { message: active_todo_counter.message }, status: :ok
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :completed)
  end

  def handle_parameter_missing(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end