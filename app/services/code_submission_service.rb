class CodeSubmissionService
  attr_reader :user, :exercise, :code, :result, :progress, :submission

  Result = Struct.new(
    :success,
    :output,
    :errors,
    :test_results,
    :execution_time,
    :attempts,
    :completed,
    :points_earned,
    :total_points,
    :solution_viewed,
    :level_up,
    :new_level,
    :new_achievements,
    keyword_init: true
  )

  def initialize(user:, exercise:, code:)
    @user = user
    @exercise = exercise
    @code = code
  end

  def call
    @result = execute_code
    @progress = user.progress_for(exercise)

    record_attempt
    create_submission
    process_completion if result.success

    build_result
  end

  def self.call(user:, exercise:, code:)
    new(user: user, exercise: exercise, code: code).call
  end

  private

  def execute_code
    CodeExecutionService.call(exercise: exercise, code: code)
  end

  def record_attempt
    progress.increment_attempts!
    progress.update!(last_code: code)
    progress.update!(status: :in_progress) if progress.not_started?
  end

  def create_submission
    @submission = user.code_submissions.create!(
      exercise: exercise,
      code: code,
      result: format_result_for_storage,
      passed: result.success,
      execution_time: result.execution_time
    )
  end

  def process_completion
    return if progress.completed?

    @old_level = user.level
    points = calculate_points
    progress.complete!(points)

    if points.positive?
      user.add_points!(points)
      check_achievements
    end
  end

  def calculate_points
    progress.solution_viewed? ? 0 : exercise.points
  end

  def check_achievements
    @new_achievements = AchievementService.new(user).check_and_award_all
  end

  def build_result
    Result.new(
      success: result.success,
      output: result.output,
      errors: Array(result.errors),
      test_results: format_test_results,
      execution_time: result.execution_time,
      attempts: progress.attempts,
      completed: progress.completed?,
      points_earned: points_earned,
      total_points: user.total_points,
      solution_viewed: progress.solution_viewed?,
      level_up: level_up?,
      new_level: user.level,
      new_achievements: formatted_achievements
    )
  end

  def points_earned
    return 0 unless result.success && progress.completed?

    progress.points_earned
  end

  def level_up?
    return false unless @old_level

    user.level > @old_level
  end

  def formatted_achievements
    return [] unless @new_achievements

    @new_achievements.map do |achievement|
      { name: achievement.name, badge_icon: achievement.badge_icon }
    end
  end

  def format_test_results
    return { examples: [] } if result.test_results.blank?

    examples = result.test_results.map do |tr|
      {
        full_description: tr[:description] || tr["description"],
        status: tr[:status] || tr["status"],
        exception: tr[:exception] ? { message: tr[:exception] } : nil
      }
    end

    { examples: examples }
  end

  def format_result_for_storage
    {
      success: result.success,
      output: result.output,
      errors: result.errors,
      test_results: result.test_results,
      execution_time: result.execution_time
    }.to_json
  end
end
