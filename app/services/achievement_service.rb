class AchievementService
  attr_reader :user, :newly_earned

  def initialize(user)
    @user = user
    @newly_earned = []
  end

  def check_and_award_all
    Achievement.find_each do |achievement|
      award(achievement) if should_award?(achievement)
    end
    newly_earned
  end

  def award(achievement)
    return false if user.has_achievement?(achievement)

    user.user_achievements.create!(
      achievement: achievement,
      earned_at: Time.current
    )
    @newly_earned << achievement
    true
  end

  private

  def should_award?(achievement)
    !user.has_achievement?(achievement) && achievement.requirement_met?(user)
  end
end
