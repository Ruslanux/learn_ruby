class Lesson < ApplicationRecord
  include Translatable

  has_many :exercises, dependent: :destroy

  enum :difficulty, { beginner: 0, intermediate: 1, advanced: 2, modern: 3 }

  validates :title, presence: true
  validates :module_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :ruby_version, presence: true

  scope :ordered, -> { order(:module_number, :position) }
  scope :by_module, ->(num) { where(module_number: num) }

  translates :title, :description
end
