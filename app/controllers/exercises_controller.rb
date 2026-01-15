class ExercisesController < ApplicationController
  before_action :set_lesson
  before_action :set_exercise
  before_action :authenticate_user!, only: [:submit]

  def show
    @user_progress = current_user&.progress_for(@exercise)
    @previous_submission = current_user&.code_submissions
                                       &.where(exercise: @exercise)
                                       &.order(created_at: :desc)
                                       &.first
    @initial_code = @previous_submission&.code || @exercise.starter_code
  end

  # POST /lessons/:lesson_id/exercises/:id/run
  # Runs tests without saving - available to all users
  def run
    code = params[:code].to_s

    if code.blank?
      render json: { error: "No code provided" }, status: :unprocessable_entity
      return
    end

    result = execute_code(code)

    render json: {
      success: result.success,
      output: result.output,
      errors: Array(result.errors),
      test_results: format_test_results(result.test_results),
      execution_time: result.execution_time
    }
  end

  # POST /lessons/:lesson_id/exercises/:id/submit
  # Runs tests and saves progress - requires authentication
  def submit
    code = params[:code].to_s

    if code.blank?
      render json: { error: "No code provided" }, status: :unprocessable_entity
      return
    end

    result = execute_code(code)
    user_progress = current_user.progress_for(@exercise)

    # Record the attempt
    user_progress.increment_attempts!
    user_progress.update!(last_code: code)

    # Create submission record
    submission = current_user.code_submissions.create!(
      exercise: @exercise,
      code: code,
      result: format_result_for_storage(result),
      passed: result.success,
      execution_time: result.execution_time
    )

    # If passed, mark as completed and award points
    if result.success && !user_progress.completed?
      user_progress.complete!(@exercise.points)
      current_user.add_points!(@exercise.points)
    end

    render json: {
      success: result.success,
      output: result.output,
      errors: Array(result.errors),
      test_results: format_test_results(result.test_results),
      execution_time: result.execution_time,
      attempts: user_progress.attempts,
      completed: user_progress.completed?,
      points_earned: result.success ? @exercise.points : 0,
      total_points: current_user.total_points
    }
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def set_exercise
    @exercise = @lesson.exercises.find(params[:id])
  end

  def execute_code(code)
    sandbox_class = ENV["USE_DOCKER_SANDBOX"] == "true" ? DockerSandboxService : RubySandboxService
    sandbox = sandbox_class.new(
      user_code: code,
      test_code: @exercise.test_code
    )
    sandbox.execute
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

  def format_result_for_storage(result)
    {
      success: result.success,
      output: result.output,
      errors: result.errors,
      test_results: result.test_results,
      execution_time: result.execution_time
    }.to_json
  end
end
