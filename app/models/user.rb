class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_progresses, dependent: :destroy
  has_many :code_submissions, dependent: :destroy
  has_many :exercises, through: :user_progresses
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/,
                                 message: "can only contain letters, numbers and underscores" }

  # Level thresholds (points required for each level)
  LEVEL_THRESHOLDS = [
    0,      # Level 1
    50,     # Level 2
    150,    # Level 3
    300,    # Level 4
    500,    # Level 5
    750,    # Level 6
    1050,   # Level 7
    1400,   # Level 8
    1800,   # Level 9
    2250    # Level 10
  ].freeze

  def progress_for(exercise)
    user_progresses.find_or_create_by(exercise: exercise)
  end

  def completed_exercises_count
    user_progresses.completed.count
  end

  def add_points!(points)
    increment!(:total_points, points)
    update_level!
    update_streak!
    check_achievements!
  end

  def update_streak!
    today = Date.current

    if last_activity_date.nil?
      # First activity
      update!(current_streak: 1, longest_streak: 1, last_activity_date: today)
    elsif last_activity_date == today
      # Already active today, no change
    elsif last_activity_date == today - 1
      # Consecutive day
      new_streak = current_streak + 1
      new_longest = [longest_streak, new_streak].max
      update!(current_streak: new_streak, longest_streak: new_longest, last_activity_date: today)
    else
      # Streak broken
      update!(current_streak: 1, last_activity_date: today)
    end
  end

  def check_achievements!
    AchievementService.new(self).check_and_award_all
  end

  def has_achievement?(achievement)
    achievements.include?(achievement)
  end

  def recent_achievements(limit = 5)
    user_achievements.recent.limit(limit).includes(:achievement)
  end

  def points_to_next_level
    return 0 if level >= LEVEL_THRESHOLDS.length

    LEVEL_THRESHOLDS[level] - total_points
  end

  def level_progress_percentage
    return 100 if level >= LEVEL_THRESHOLDS.length

    current_threshold = LEVEL_THRESHOLDS[level - 1]
    next_threshold = LEVEL_THRESHOLDS[level]
    points_in_level = total_points - current_threshold
    points_needed = next_threshold - current_threshold

    ((points_in_level.to_f / points_needed) * 100).clamp(0, 100).round
  end

  def rank
    User.where("total_points > ?", total_points).count + 1
  end

  private

  def update_level!
    new_level = calculate_level
    update!(level: new_level) if new_level > level
  end

  def calculate_level
    LEVEL_THRESHOLDS.each_with_index do |threshold, index|
      return index if total_points < threshold
    end
    LEVEL_THRESHOLDS.length
  end
end
