# frozen_string_literal: true

class CodeExecutionJob < ApplicationJob
  queue_as :code_execution

  # Retry on transient failures
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(submission_id)
    submission = CodeSubmission.find(submission_id)
    exercise = submission.exercise

    # Execute code in sandbox
    result = RubySandboxService.new(
      user_code: submission.code,
      test_code: exercise.test_code
    ).execute

    # Update submission with results
    submission.update!(
      result: result.output.presence || result.errors,
      passed: result.success,
      execution_time: result.execution_time
    )

    # If passed, update user progress
    if result.success
      update_user_progress(submission)
    end

    # Broadcast result via Turbo Streams if ActionCable is configured
    broadcast_result(submission, result)
  end

  private

  def update_user_progress(submission)
    progress = UserProgress.find_or_initialize_by(
      user: submission.user,
      exercise: submission.exercise
    )

    # Only award points on first completion
    first_completion = !progress.persisted? || !progress.completed?

    progress.status = :completed
    progress.completed_at ||= Time.current
    progress.last_code = submission.code

    if first_completion
      progress.points_earned = submission.exercise.points
      progress.save!
      submission.user.add_points!(submission.exercise.points)

      # Check for achievements asynchronously
      AchievementCheckJob.perform_later(submission.user_id)
    else
      progress.save!
    end
  end

  def broadcast_result(submission, result)
    # Broadcast to user's channel if ActionCable is set up
    ActionCable.server.broadcast(
      "user_#{submission.user_id}_submissions",
      {
        submission_id: submission.id,
        success: result.success,
        output: result.output,
        errors: result.errors,
        test_results: result.test_results,
        execution_time: result.execution_time
      }
    )
  rescue StandardError
    # ActionCable might not be configured, ignore
  end
end
