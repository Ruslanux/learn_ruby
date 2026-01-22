module Api
  module V1
    class LessonsController < BaseController
      def index
        @lessons = Lesson.includes(:exercises).order(:module_number, :position)

        render json: {
          lessons: LessonSerializer.serialize_collection(
            @lessons,
            current_user: current_user,
            progress_data: preload_progress_data(@lessons)
          )
        }
      end

      def show
        @lesson = Lesson.find(params[:id])
        @exercises = @lesson.exercises.order(:position)

        render json: {
          lesson: LessonSerializer.serialize(
            @lesson,
            include_exercises: true,
            exercises: @exercises,
            current_user: current_user,
            exercise_progress: preload_exercise_progress(@exercises)
          )
        }
      end

      private

      # Preload completed counts for all lessons in a single query
      def preload_progress_data(lessons)
        return {} unless current_user

        current_user.user_progresses
                    .joins(:exercise)
                    .where(exercises: { lesson_id: lessons.pluck(:id) })
                    .completed
                    .group("exercises.lesson_id")
                    .count
      end

      # Preload progress for all exercises in a single query
      def preload_exercise_progress(exercises)
        return {} unless current_user

        current_user.user_progresses
                    .where(exercise_id: exercises.pluck(:id))
                    .index_by(&:exercise_id)
      end
    end
  end
end
