class ExercisesController < ApplicationController
  before_action :set_lesson
  before_action :set_exercise
  before_action :authenticate_user!, only: [:submit, :view_solution]

  def show
    @user_progress = current_user&.progress_for(@exercise)
    @previous_submission = current_user&.code_submissions
                                       &.where(exercise: @exercise)
                                       &.order(created_at: :desc)
                                       &.first
    @initial_code = @previous_submission&.code || @exercise.starter_code
  end

  def run
    result = CodeExecutionService.call(exercise: @exercise, code: params[:code])

    if result.errors.include?("No code provided")
      render json: { error: "No code provided" }, status: :unprocessable_entity
      return
    end

    render json: {
      success: result.success,
      output: result.output,
      errors: Array(result.errors),
      test_results: format_test_results(result.test_results),
      execution_time: result.execution_time
    }
  end

  def submit
    if params[:code].blank?
      render json: { error: "No code provided" }, status: :unprocessable_entity
      return
    end

    result = CodeSubmissionService.call(
      user: current_user,
      exercise: @exercise,
      code: params[:code]
    )

    render json: result.to_h
  end

  def view_solution
    user_progress = current_user.progress_for(@exercise)
    user_progress.update!(solution_viewed: true)

    render json: { success: true }
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def set_exercise
    @exercise = @lesson.exercises.find(params[:id])
  end

  def format_test_results(test_results)
    return { examples: [] } if test_results.blank?

    examples = test_results.map do |result|
      {
        full_description: result[:description] || result["description"],
        status: result[:status] || result["status"],
        exception: result[:exception] ? { message: result[:exception] } : nil
      }
    end

    { examples: examples }
  end
end
