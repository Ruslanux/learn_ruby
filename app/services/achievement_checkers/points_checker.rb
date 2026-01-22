# frozen_string_literal: true

module AchievementCheckers
  class PointsChecker < BaseChecker
    def met?
      user.total_points >= required_points
    end

    private

    def required_points
      achievement.points_required || 0
    end
  end
end
