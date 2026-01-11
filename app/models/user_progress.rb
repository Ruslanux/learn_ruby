class UserProgress < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  validates :user_id, uniqueness: { scope: :exercise_id }
  validates :attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :points_earned, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :completed, -> { where(status: :completed) }
  scope :in_progress, -> { where(status: :in_progress) }

  def complete!(points = nil)
    points ||= exercise.points
    update!(
      status: :completed,
      completed_at: Time.current,
      points_earned: points
    )
  end

  def increment_attempts!
    increment!(:attempts)
    update!(status: :in_progress) if not_started?
  end
end
