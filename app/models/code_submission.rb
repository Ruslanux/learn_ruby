class CodeSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  validates :code, presence: true

  scope :passed, -> { where(passed: true) }
  scope :failed, -> { where(passed: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_exercise, ->(exercise) { where(exercise: exercise) }
end
