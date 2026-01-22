# frozen_string_literal: true

class UserProgressQuery < BaseQuery
  def initialize(user)
    @user = user
    super(default_relation)
  end

  def call
    relation
  end

  # Get progress indexed by exercise_id for quick lookup
  def indexed_by_exercise
    relation.includes(:exercise).index_by(&:exercise_id)
  end

  # Get completed exercises with lesson info
  def completed_with_lesson(limit: nil)
    scope = relation.completed
                    .includes(exercise: :lesson)
                    .order(completed_at: :desc)
    limit ? scope.limit(limit) : scope
  end

  # Get in-progress exercises with lesson info
  def in_progress_with_lesson
    relation.in_progress.includes(exercise: :lesson)
  end

  # Preload completed counts grouped by lesson_id
  def completed_counts_by_lesson(lesson_ids)
    relation.joins(:exercise)
            .where(exercises: { lesson_id: lesson_ids })
            .completed
            .group("exercises.lesson_id")
            .count
  end

  # Preload progress for specific exercises
  def for_exercises(exercise_ids)
    relation.where(exercise_id: exercise_ids).index_by(&:exercise_id)
  end

  private

  def default_relation
    @user.user_progresses
  end
end
