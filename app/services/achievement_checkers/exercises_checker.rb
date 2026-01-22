# frozen_string_literal: true

module AchievementCheckers
  class ExercisesChecker < BaseChecker
    def met?
      user.completed_exercises_count >= required_exercises
    end

    private

    def required_exercises
      achievement.exercises_required || 0
    end
  end
end
