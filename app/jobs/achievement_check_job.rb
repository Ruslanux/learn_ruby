# frozen_string_literal: true

class AchievementCheckJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    AchievementService.new(user).check_and_award_all
  end
end
