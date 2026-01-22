# frozen_string_literal: true

module AchievementCheckers
  class StreakChecker < BaseChecker
    def met?
      user.longest_streak >= required_streak
    end

    private

    def required_streak
      achievement.streak_required || 0
    end
  end
end
