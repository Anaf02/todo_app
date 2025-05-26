# frozen_string_literal: true
require 'dry/matcher/result_matcher'

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    result = Container["todo_transactions.create"].call(todo_params.to_h)
    Dry::Transaction::ResultMatcher.call(result) do |m|
      m.success do |value|
        render json: TodoSerializer.new(value).as_json, status: :created
      end

      m.failure do |error|
        render json: { error: error }, status: :unprocessable_entity
      end
    end
  end

  def index
    page = params[:page]
    per_page = params[:per_page]
    result = Container["todo_transactions.get"].call(filtering_params.to_h)
    active_todo_counter = ActiveTodoCounter.new
    active_count = active_todo_counter.count

    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do |value|
        todos = value
        paginated_todos = PaginationService.new(todos, page: page, per_page: per_page).call

        render json: {
          todos: paginated_todos.map { |todo| TodoSerializer.new(todo).as_json },
          metadata: {
            active: {
              count: active_count,
              formatted_message: active_todo_counter.message
            }
          }
        }
      end

      m.failure do |error|
        render json: { error: error }, status: :unprocessable_entity
      end
    end
  end

  def update
    result = Container["todo_transactions.update"].call(update_params)
    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do |value|
        render json: TodoSerializer.new(value).as_json, status: :ok
      end
      m.failure do |error|
        render json: { error: error }, status: :not_found
      end
    end
  end

  def delete_all
    result = Container["todo_transactions.delete_all"].call(delete_filtering_params.to_h)

    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success(Integer) do |value|
        render json: { message: "#{value} todo(s) have been deleted" }, status: :ok
      end

      m.failure do |error|
        render json: { error: error }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    result = Container["todo_transactions.destroy"].call(id: params[:id].to_i)
    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do
        render json: { message: "Todo deleted" }, status: :ok
      end

      m.failure do
        render json: { error: result.failure }, status: :not_found
      end
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :completed)
  end

  def filtering_params
    params.permit(:name, :completed)
  end

  def update_params
    {
      id: params[:id].to_i,
      name: params[:name],
      completed: ActiveModel::Type::Boolean.new.cast(params[:completed])
    }.compact
  end

  def delete_filtering_params
    return {} unless params.key?(:completed)
    { completed: ActiveModel::Type::Boolean.new.cast(params[:completed]) }
  end

  def handle_parameter_missing(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
