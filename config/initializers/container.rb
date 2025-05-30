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
