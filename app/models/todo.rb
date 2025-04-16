# frozen_string_literal: true
class Todo < ApplicationRecord
  include Filterable

  validates :name, presence: true
  validates :completed, inclusion: { in: [ true, false ] }

  scope :filter_by_completed, ->(value) { where(completed: ActiveModel::Type::Boolean.new.cast(value)) }
end
