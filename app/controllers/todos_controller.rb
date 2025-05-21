# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

  def create
    result = ::Transactions::Todos::Create.new.call(todo_params.to_h)
    if result.success?
      render json: TodoSerializer.new(result.value!).as_json, status: :created
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  end

  def index
    page = params[:page]
    per_page = params[:per_page]
    todos = ::Transactions::Todos::Get.new.call(filtering_params.to_h).value!.page(page || DEFAULT_PAGE).per(per_page || DEFAULT_PER_PAGE)
    active_todo_counter = ActiveTodoCounter.new
    active_count = active_todo_counter.count

    render json: {
      todos: todos.map { |todo| TodoSerializer.new(todo).as_json },
      metadata: {
        active: {
          count: active_count,
          formatted_message: active_todo_counter.message
        }
      }
    }
  end

  def update
    input_hash = filtering_params.to_h.merge(id: params[:id].to_i)
    result = ::Transactions::Todos::Update.new.call(input_hash)
    if result.success?
      render json: TodoSerializer.new(result.value!).as_json, status: :ok
    else
      render json: { error: result.failure }, status: :not_found
    end
  end

  def delete_all
    result = ::Transactions::Todos::DeleteAll.new.call(delete_filtering_params.to_h)
    if result.success?
      render json: { message: "#{result.value!} todo(s) have been deleted" }, status: :ok
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  end

  def destroy
    result = ::Transactions::Todos::Destroy.new.call(id: params[:id].to_i)
    if result.success?
      render json: { message: "Todo deleted" }, status: :ok
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :completed)
  end

  def filtering_params
    params.permit(:name, :completed)
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
