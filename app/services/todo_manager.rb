# frozen_string_literal: true
class TodoManager
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

  Result = Struct.new(:success?, :data, :errors, keyword_init: true)

  def initialize(repository = TodoRepository.new)
    @repository = repository
  end

  def create_todo(todo_params)
    todo = @repository.build(todo_params)
    if @repository.save(todo)
      Result.new(success?: true, data: todo)
    else
      Result.new(success?: false, errors: todo.errors)
    end
  end

  def get_all_todos(filtering_params, page, per_page)
    page = DEFAULT_PAGE unless page.present?
    per_page = DEFAULT_PER_PAGE unless per_page.present?

    begin
      todos = @repository.all(filtering_params).page(page).per(per_page)
      todos = [] if todos.nil?
      Result.new(success?: true, data: todos)

    rescue => e
      Result.new(success?: false, errors: e.message)
    end
  end

  def update_todo(id, todo_params)
    todo = @repository.find(id)
    return Result.new(success?: false, errors: "Todo not found") unless todo

    if @repository.update(id, todo_params)
      updated_todo = @repository.find(id)
      Result.new(success?: true, data: updated_todo)
    else
      Result.new(success?: false, errors: "Failed to update todo")
    end
  end

  def destroy_todo(id)
    todo = @repository.find(id)
    return Result.new(success?: false, errors: "Todo not found") unless todo

    if @repository.delete(id)
      Result.new(success?: true)
    else
      Result.new(success?: false, errors: todo.errors)
    end
  end

  def destroy_all(delete_filtering_params)
    begin
      destroyed_count = @repository.delete_all(delete_filtering_params)
      Result.new(success?: true, data: destroyed_count)
    rescue => e
      Result.new(success?: false, errors: e.message)
    end
  end
end