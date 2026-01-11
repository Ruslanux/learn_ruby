class LessonsController < ApplicationController
  before_action :set_lesson, only: :show

  def index
    @modules = Lesson.ordered.group_by(&:module_number)
    @user_progress = current_user_progress
  end

  def show
    @exercises = @lesson.exercises.ordered
    @user_progress = current_user_progress
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def current_user_progress
    return {} unless user_signed_in?

    UserProgress.where(user: current_user)
                .includes(:exercise)
                .index_by(&:exercise_id)
  end
end
