module Api
  module V1
    class ExercisesController < BaseController
      before_action :set_exercise

      def show
        progress = current_user.progress_for(@exercise)

        render json: {
          exercise: exercise_json(@exercise, progress)
        }
      end

      def run
        code = params[:code].to_s

        if code.blank?
          render json: { error: "No code provided" }, status: :unprocessable_entity
          return
        end

        result = execute_in_sandbox(code)

        render json: {
          success: result.success,
          output: result.output,
          errors: result.errors,
          test_results: result.test_results,
          execution_time: result.execution_time
        }
      end

      def submit
        code = params[:code].to_s

        if code.blank?
          render json: { error: "No code provided" }, status: :unprocessable_entity
          return
        end

        progress = current_user.progress_for(@exercise)

        result = execute_in_sandbox(code)

        # Record the submission
        submission = current_user.code_submissions.create!(
          exercise: @exercise,
          code: code,
          result: result.output,
          passed: result.success,
          execution_time: result.execution_time
        )

        # Update progress
        progress.increment!(:attempts)
        progress.update!(last_code: code, status: :in_progress) if progress.not_started?

        points_earned = 0
        level_up = false
        new_achievements = []

        if result.success && !progress.completed?
          progress.update!(status: :completed, completed_at: Time.current, points_earned: @exercise.points)
          points_earned = @exercise.points

          old_level = current_user.level
          current_user.add_points!(points_earned)
          level_up = current_user.level > old_level

          # Check for new achievements
          new_achievements = AchievementService.new(current_user).newly_earned.map do |achievement|
            { name: achievement.name, badge_icon: achievement.badge_icon }
          end
        end

        render json: {
          success: result.success,
          output: result.output,
          errors: result.errors,
          test_results: result.test_results,
          execution_time: result.execution_time,
          attempts: progress.attempts,
          completed: progress.completed?,
          points_earned: points_earned,
          level_up: level_up,
          new_level: current_user.level,
          new_achievements: new_achievements
        }
      end

      private

      def set_exercise
        @exercise = Exercise.find(params[:id])
      end

      def execute_in_sandbox(code)
        sandbox_class = ENV["USE_DOCKER_SANDBOX"] == "true" ? DockerSandboxService : RubySandboxService
        sandbox_class.new(
          user_code: code,
          test_code: @exercise.test_code
        ).execute
      end

      def exercise_json(exercise, progress)
        {
          id: exercise.id,
          title: exercise.title,
          description: exercise.description,
          instructions: exercise.instructions,
          hints: exercise.hints || [],
          topics: exercise.topics || [],
          starter_code: exercise.starter_code,
          test_code: exercise.test_code,
          points: exercise.points,
          lesson: {
            id: exercise.lesson.id,
            title: exercise.lesson.title
          },
          progress: {
            status: progress.status,
            attempts: progress.attempts,
            completed: progress.completed?,
            last_code: progress.last_code,
            points_earned: progress.points_earned
          }
        }
      end
    end
  end
end
