# frozen_string_literal: true

module AchievementCheckers
  class FirstStepsChecker < BaseChecker
    def met?
      user.completed_exercises_count >= 1
    end
  end
end
