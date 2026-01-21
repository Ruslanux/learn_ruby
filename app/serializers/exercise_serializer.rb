class ExerciseSerializer < ApplicationSerializer
  def as_json
    case options[:variant]
    when :summary
      summary_json
    else
      full_json
    end
  end

  private

  def summary_json
    {
      id: object.id,
      title: object.title,
      points: object.points,
      position: object.position,
      status: progress.status,
      completed: progress.completed?
    }
  end

  def full_json
    {
      id: object.id,
      title: object.title,
      description: object.description,
      instructions: object.instructions,
      hints: object.hints || [],
      topics: object.topics || [],
      starter_code: object.starter_code,
      test_code: object.test_code,
      points: object.points,
      lesson: lesson_json,
      progress: progress_json
    }
  end

  def lesson_json
    {
      id: object.lesson.id,
      title: object.lesson.title
    }
  end

  def progress_json
    {
      status: progress.status,
      attempts: progress.attempts,
      completed: progress.completed?,
      last_code: progress.last_code,
      points_earned: progress.points_earned
    }
  end

  def progress
    @progress ||= options[:progress] || current_user&.progress_for(object) || NullProgress.new
  end

  class NullProgress
    def status = :not_started
    def attempts = 0
    def completed? = false
    def last_code = nil
    def points_earned = 0
  end
end
