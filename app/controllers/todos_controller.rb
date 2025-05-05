# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

  def create
    todo_manager = TodoManager.new
    result = todo_manager.create_todo(todo_params)
    if result.success?
      render json: TodoSerializer.new(result.todo).as_json, status: :created
    else
      render json: { error: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    todo_manager = TodoManager.new
    page = params[:page]
    per_page = params[:per_page]
    result = todo_manager.get_all_todos(filtering_params, page, per_page)
    active_todo_counter = ActiveTodoCounter.new
    active_count = active_todo_counter.count

    render json: {
      todos: result.todo.map { |todo| TodoSerializer.new(todo).as_json },
      metadata: {
        active: {
          count: active_count,
          formatted_message: active_todo_counter.message
        }
      }
    }
  end

  def update
    todo_manager = TodoManager.new
    result = todo_manager.update_todo(params[:id], todo_params)
    if result.success?
      render json: TodoSerializer.new(result.todo).as_json, status: :ok
    else
      render json: { error: result.errors }, status: :not_found
    end
  end

  def delete_all
    todo_manager = TodoManager.new
    result = todo_manager.destroy_all_completed_todos(delete_filtering_params)
    if result.success?
      render json: { message: "#{result.todo} todo(s) have been deleted" }, status: :ok
    else
      render json: { error: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    todo_manager = TodoManager.new
    result = todo_manager.destroy_todo(params[:id])
    if result.success?
      render json: { message: "Todo deleted" }, status: :ok
    else
      render json: { error: result.errors }, status: :unprocessable_entity
    end
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