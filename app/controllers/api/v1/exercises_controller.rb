module Api
  module V1
    class ExercisesController < BaseController
      before_action :set_exercise

      def show
        progress = current_user.progress_for(@exercise)

        render json: {
          exercise: ExerciseSerializer.serialize(@exercise, progress: progress, current_user: current_user)
        }
      end

      def run
        result = CodeExecutionService.call(exercise: @exercise, code: params[:code])

        if result.errors.include?("No code provided")
          render json: { error: "No code provided" }, status: :unprocessable_entity
          return
        end

        render json: {
          success: result.success,
          output: result.output,
          errors: result.errors,
          test_results: result.test_results,
          execution_time: result.execution_time
        }
      end

      def submit
        if params[:code].blank?
          render json: { error: "No code provided" }, status: :unprocessable_entity
          return
        end

        result = CodeSubmissionService.call(
          user: current_user,
          exercise: @exercise,
          code: params[:code]
        )

        render json: result.to_h
      end

      private

      def set_exercise
        @exercise = Exercise.find(params[:id])
      end
    end
  end
end
