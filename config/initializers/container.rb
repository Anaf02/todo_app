# frozen_string_literal: true
require 'dry-container'
require 'dry-auto_inject'
require 'dry/system'

class Container < Dry::System::Container
  configure do |config|
    config.root = Pathname("/app")
    config.component_dirs.add "lib"
  end
end

Container.register(:todo_repository, -> { TodoRepository.new })

Import = Container.injector

#
# Container.namespace "todo_contracts" do
#   register "create", -> { Contracts::Todos::Create.new }
#   register "delete_all", -> { Contracts::Todos::DeleteAll.new }
#   register "destroy", -> { Contracts::Todos::Destroy.new }
#   register "get", -> { Contracts::Todos::Get.new }
#   register "update", -> { Contracts::Todos::Update.new }
# end
#
# Container.namespace "todo_transactions" do
#   register "create", -> { Transactions::Todos::Create.new }
#   register "delete_all", -> { Transactions::Todos::DeleteAll.new }
#   register "destroy", -> { Transactions::Todos::Destroy.new }
#   register "get", -> { Transactions::Todos::Get.new }
#   register "update", -> { Transactions::Todos::Update.new }
# end
#
# Container.namespace "operations" do
#   namespace "todos" do
#     register "create", -> {
#       Operations::Todos::Create.new
#     }
#     register "delete_all", -> {
#       Operations::Todos::DeleteAll.new
#     }
#     register "destroy", -> {
#       Operations::Todos::Destroy.new
#     }
#     register "get", -> {
#       Operations::Todos::Get.new
#     }
#     register "update", -> {
#       Operations::Todos::Update.new
#     }
#   end
# end
#
# Container.namespace "contracts" do
#   namespace "todos" do
#     register "create", -> {
#       Operations::Validate.new(Container.resolve("todo_contracts.create"))
#     }
#     register "delete_all", -> {
#       Operations::Validate.new(Container.resolve("todo_contracts.delete_all"))
#     }
#     register "destroy", -> {
#       Operations::Validate.new(Container.resolve("todo_contracts.destroy"))
#     }
#     register "get", -> {
#       Operations::Validate.new(Container.resolve("todo_contracts.get"))
#     }
#     register "update", -> {
#       Operations::Validate.new(Container.resolve("todo_contracts.update"))
#     }
#   end
# end

