class ActiveTodoCounter
  attr_reader :count

  def count(todos)
    @count = todos.select { |todo| todo.completed == false }.count
  end

  def message
    @count == 1 ? "1 item left!" : "#{@count} items left!"
  end
end