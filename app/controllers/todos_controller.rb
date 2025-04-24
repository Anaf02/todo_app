# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

  def create
    todo = Todo.create(todo_params)
    if todo.persisted?
      render json: TodoSerializer.new(todo).as_json, status: :created
    else
      render json: { error: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    page = params[:page] || DEFAULT_PAGE
    per_page = params[:per_page] || DEFAULT_PER_PAGE
    @todos = Todo.filter(filtering_params).page(page).per(per_page)
    active_todo_counter = ActiveTodoCounter.new
    active_count = active_todo_counter.count

    render json: {
      todos: @todos.map { |todo| TodoSerializer.new(todo).as_json },
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
      render json: TodoSerializer.new(@todo).as_json, status: :ok
    else
      render json: { error: @todo.errors.full_messages }, status: :not_found
    end
  end

  def delete_all
    deleted_count = Todo.filter(delete_filtering_params).destroy_all.size

    render json: { message: "#{deleted_count} todo(s) have been deleted" }, status: :ok
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render json: { message: "Todo deleted" }, status: :ok
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :completed)
  end

  def filtering_params
    params.slice(:completed, :name)
  end

  def delete_filtering_params
    return {} unless params.key?(:completed)

    if params[:completed] == "true"
      { completed: true }
    else
      raise ActionController::ParameterMissing.new(:completed)
    end
  end

  def handle_parameter_missing(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end