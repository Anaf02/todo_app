# frozen_string_literal: true
require 'dry/matcher/result_matcher'

class TodosController < ApplicationController
  include ::ErrorHandlingConcern
  include ::TransactionInputBuilderConcern

  def create
    result = Container["transactions.todos.create"]
               .call(transaction_input(Container["contracts.todos.create"], todo_params))
    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do |value|
        render json: TodoSerializer.new(value).as_json, status: :created
      end
      m.failure do |error|
        render_failures(error, :unprocessable_entity)
      end
    end
  end

  def index
    page = params[:page]
    per_page = params[:per_page]
    result = Container["transactions.todos.get"]
               .call(transaction_input(Container["contracts.todos.get"], filtering_params))
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
        render_failures(error, :unprocessable_entity)
      end
    end
  end

  def update
    result = Container["transactions.todos.update"]
               .call(transaction_input(Container["contracts.todos.update"], update_params))
    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do |value|
        render json: TodoSerializer.new(value).as_json, status: :ok
      end
      m.failure do |error|
        render_failures(error, :not_found)
      end
    end
  end

  def delete_all
    result = Container["transactions.todos.delete_all"]
               .call(transaction_input(Container["contracts.todos.delete_all"], delete_filtering_params))

    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success(Integer) do |value|
        render json: { message: "#{value} todo(s) have been deleted" }, status: :ok
      end

      m.failure do |error|
        render_failures(error, :unprocessable_entity)
      end
    end
  end

  def destroy
    result = Container["transactions.todos.destroy"]
               .call(transaction_input(Container["contracts.todos.destroy"], id: params[:id].to_i))
    Dry::Matcher::ResultMatcher.call(result) do |m|
      m.success do
        render json: { message: "Todo deleted" }, status: :ok
      end

      m.failure do |error|
        render_failures(error, :not_found)
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

end
