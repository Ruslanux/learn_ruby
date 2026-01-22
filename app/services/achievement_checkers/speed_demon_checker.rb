# frozen_string_literal: true

module AchievementCheckers
  class SpeedDemonChecker < BaseChecker
    MAX_EXECUTION_TIME = 0.1

    def met?
      user.code_submissions
          .where(passed: true)
          .where("execution_time < ?", MAX_EXECUTION_TIME)
          .exists?
    end
  end
end
