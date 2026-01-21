class LessonSerializer < ApplicationSerializer
  def as_json
    json = {
      id: object.id,
      title: object.title,
      description: object.description,
      module_number: object.module_number,
      position: object.position,
      difficulty: object.difficulty,
      ruby_version: object.ruby_version,
      exercises_count: object.exercises.count,
      progress: progress_json
    }

    json[:exercises] = exercises_json if options[:include_exercises]

    json
  end

  private

  def progress_json
    total = object.exercises.count
    return { completed: 0, total: 0, percentage: 0 } if total.zero?

    completed = completed_count

    {
      completed: completed,
      total: total,
      percentage: ((completed.to_f / total) * 100).round
    }
  end

  def completed_count
    return 0 unless current_user

    current_user.user_progresses
                .joins(:exercise)
                .where(exercises: { lesson_id: object.id })
                .completed
                .count
  end

  def exercises_json
    exercises = options[:exercises] || object.exercises.order(:position)
    exercises.map { |e| ExerciseSerializer.serialize(e, variant: :summary, current_user: current_user) }
  end
end
