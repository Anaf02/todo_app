class ActiveTodoCounter
  attr_reader :message, :count

  def count(todos)
    @count = todos.select { |todo| todo.completed == false }.count
  end

  def message
    @count == 1 ? @message = "#{@count} item left!" : @message = "#{@count} items left!"
  end
end