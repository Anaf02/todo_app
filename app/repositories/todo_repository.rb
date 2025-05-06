# frozen_string_literal: true

class TodoRepository
  def initialize(db = Todo)
    @db = db
  end

  def build(params)
    @db.new(params)
  end

  def save(todo)
    todo.save
  end

  def find(id)
    @db.find(id)
  end

  def all(filtering_params)
    @db.filter(filtering_params)
  end

  def update(id, attributes)
    todo = find(id)
    todo.update(attributes)
  end

  def delete(id)
    todo = find(id)
    todo.destroy
  end

  def delete_all(filtering_params)
    @db.filter(filtering_params).destroy_all.size
  end
end
