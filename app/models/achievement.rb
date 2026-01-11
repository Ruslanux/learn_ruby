class Achievement < ApplicationRecord
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements

  enum :category, {
    points: 0,      # Based on total points earned
    exercises: 1,   # Based on exercises completed
    streak: 2,      # Based on daily streak
    special: 3      # Special achievements (first exercise, etc.)
  }

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :badge_icon, presence: true
  validates :category, presence: true

  scope :ordered, -> { order(:category, :points_required, :exercises_required, :streak_required) }

  def earned_by?(user)
    user_achievements.exists?(user: user)
  end

  def requirement_met?(user)
    case category
    when "points"
      user.total_points >= (points_required || 0)
    when "exercises"
      user.completed_exercises_count >= (exercises_required || 0)
    when "streak"
      user.longest_streak >= (streak_required || 0)
    when "special"
      check_special_requirement(user)
    else
      false
    end
  end

  private

  def check_special_requirement(user)
    case name
    when "First Steps"
      user.completed_exercises_count >= 1
    when "Perfect Score"
      user.user_progresses.completed.where(attempts: 1).exists?
    when "Night Owl"
      user.code_submissions.where("extract(hour from created_at) >= 22 OR extract(hour from created_at) < 6").exists?
    when "Speed Demon"
      user.code_submissions.where(passed: true).where("execution_time < 0.1").exists?
    else
      false
    end
  end
end
