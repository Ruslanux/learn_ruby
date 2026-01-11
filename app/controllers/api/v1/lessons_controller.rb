module Api
  module V1
    class LessonsController < BaseController
      def index
        @lessons = Lesson.includes(:exercises).order(:module_number, :position)

        render json: {
          lessons: @lessons.map { |lesson| lesson_json(lesson) }
        }
      end

      def show
        @lesson = Lesson.find(params[:id])
        @exercises = @lesson.exercises.order(:position)

        render json: {
          lesson: lesson_json(@lesson, include_exercises: true)
        }
      end

      private

      def lesson_json(lesson, include_exercises: false)
        json = {
          id: lesson.id,
          title: lesson.title,
          description: lesson.description,
          module_number: lesson.module_number,
          position: lesson.position,
          difficulty: lesson.difficulty,
          ruby_version: lesson.ruby_version,
          exercises_count: lesson.exercises.count,
          progress: lesson_progress(lesson)
        }

        if include_exercises
          json[:exercises] = @exercises.map { |e| exercise_summary_json(e) }
        end

        json
      end

      def exercise_summary_json(exercise)
        progress = current_user.progress_for(exercise)

        {
          id: exercise.id,
          title: exercise.title,
          points: exercise.points,
          position: exercise.position,
          status: progress.status,
          completed: progress.completed?
        }
      end

      def lesson_progress(lesson)
        total = lesson.exercises.count
        return { completed: 0, total: 0, percentage: 0 } if total.zero?

        completed = current_user.user_progresses
                                .joins(:exercise)
                                .where(exercises: { lesson_id: lesson.id })
                                .completed
                                .count

        {
          completed: completed,
          total: total,
          percentage: ((completed.to_f / total) * 100).round
        }
      end
    end
  end
end
