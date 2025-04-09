# frozen_string_literal: true
class Todo < ApplicationRecord
  validates :name, presence: true
  validates :completed, presence: true
  validates :completed, inclusion: { in: [ true, false ] }
end
