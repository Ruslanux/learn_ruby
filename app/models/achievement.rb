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
    checker_class = AchievementCheckers::BaseChecker.for(self)
    checker_class.new(user, self).met?
  end
end
