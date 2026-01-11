class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @completed_exercises = @user.user_progresses.completed.includes(exercise: :lesson).order(completed_at: :desc)
    @recent_submissions = @user.code_submissions.order(created_at: :desc).limit(10).includes(:exercise)
    @achievements = @user.achievements.ordered
    @all_achievements = Achievement.ordered
  end
end
