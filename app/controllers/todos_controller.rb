# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
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
    render json: { todos: @todos }
  end

  def update
  end

  def destroy
  end

  private
  def todo_params
    params.require(:todo).permit(:name, :completed)
  end
  def handle_parameter_missing(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end