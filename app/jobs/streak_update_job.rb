# frozen_string_literal: true

class StreakUpdateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.update_streak!
  end
end
