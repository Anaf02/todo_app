# spec/factories/todos.rb
FactoryBot.define do
  factory :todo do
    name { "Task1" }
    completed { false }

    trait :completed do
      completed { true }
    end
  end
end
