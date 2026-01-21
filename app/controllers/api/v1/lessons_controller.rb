module Api
  module V1
    class LessonsController < BaseController
      def index
        @lessons = Lesson.includes(:exercises).order(:module_number, :position)

        render json: {
          lessons: LessonSerializer.serialize_collection(@lessons, current_user: current_user)
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
            current_user: current_user
          )
        }
      end
    end
  end
end
