# frozen_string_literal: true
require 'dry-container'
require 'dry-auto_inject'

class Container
  extend Dry::Container::Mixin
end

Container.register(:todo_repository, -> { TodoRepository.new })

Container.namespace "todo_contracts" do
  register "create", -> { Contracts::Todos::Create.new }
  register "delete_all", -> { Contracts::Todos::DeleteAll.new }
  register "destroy", -> { Contracts::Todos::Destroy.new }
  register "get", -> { Contracts::Todos::Get.new }
  register "update", -> { Contracts::Todos::Update.new }
end

Container.namespace "validate" do
  namespace "todos" do
    register "create", -> {
      Steps::Validate.new(Container.resolve("todo_contracts.create"))
    }
    register "delete_all", -> {
      Steps::Validate.new(Container.resolve("todo_contracts.delete_all"))
    }
    register "destroy", -> {
      Steps::Validate.new(Container.resolve("todo_contracts.destroy"))
    }
    register "get", -> {
      Steps::Validate.new(Container.resolve("todo_contracts.get"))
    }
    register "update", -> {
      Steps::Validate.new(Container.resolve("todo_contracts.update"))
    }
  end
end

Import = Dry::AutoInject(Container)
