class UserProgressSerializer < ApplicationSerializer
  def as_json
    {
      exercise_id: object.exercise.id,
      exercise_title: object.exercise.title,
      lesson_title: object.exercise.lesson.title,
      status: object.status,
      attempts: object.attempts,
      points_earned: object.points_earned,
      completed_at: object.completed_at
    }
  end
end
