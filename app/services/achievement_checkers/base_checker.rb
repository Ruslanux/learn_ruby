# frozen_string_literal: true

module AchievementCheckers
  class BaseChecker
    attr_reader :user, :achievement

    def initialize(user, achievement)
      @user = user
      @achievement = achievement
    end

    def met?
      raise NotImplementedError, "Subclasses must implement #met?"
    end

    def self.for(achievement)
      case achievement.category
      when "points"
        PointsChecker
      when "exercises"
        ExercisesChecker
      when "streak"
        StreakChecker
      when "special"
        special_checker_for(achievement.name)
      else
        NullChecker
      end
    end

    def self.special_checker_for(name)
      case name
      when "First Steps"
        FirstStepsChecker
      when "Perfect Score"
        PerfectScoreChecker
      when "Night Owl"
        NightOwlChecker
      when "Speed Demon"
        SpeedDemonChecker
      else
        NullChecker
      end
    end
  end
end
