class Exercise < ApplicationRecord
  include Translatable

  belongs_to :lesson
  has_many :user_progresses, dependent: :destroy
  has_many :code_submissions, dependent: :destroy
  has_many :users, through: :user_progresses

  validates :title, presence: true
  validates :test_code, presence: true
  validates :points, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position) }

  translates :title, :description, :instructions, :hints

  def difficulty
    lesson.difficulty
  end

  def module_number
    lesson.module_number
  end
end
