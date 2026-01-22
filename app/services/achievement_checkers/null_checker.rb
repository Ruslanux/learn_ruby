# frozen_string_literal: true

module AchievementCheckers
  class NullChecker < BaseChecker
    def met?
      false
    end
  end
end
