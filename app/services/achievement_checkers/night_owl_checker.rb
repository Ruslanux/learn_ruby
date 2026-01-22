# frozen_string_literal: true

module AchievementCheckers
  class NightOwlChecker < BaseChecker
    NIGHT_HOURS_START = 22
    NIGHT_HOURS_END = 6

    def met?
      user.code_submissions
          .where("extract(hour from created_at) >= ? OR extract(hour from created_at) < ?",
                 NIGHT_HOURS_START, NIGHT_HOURS_END)
          .exists?
    end
  end
end
