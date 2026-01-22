# frozen_string_literal: true

module AchievementCheckers
  class PerfectScoreChecker < BaseChecker
    def met?
      user.user_progresses.completed.where(attempts: 1).exists?
    end
  end
end
