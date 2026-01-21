module Api
  module V1
    class UsersController < BaseController
      def me
        render json: {
          user: UserSerializer.serialize(current_user)
        }
      end

      def progress
        completed = current_user.user_progresses.completed.includes(exercise: :lesson)
        in_progress = current_user.user_progresses.in_progress.includes(exercise: :lesson)

        render json: {
          progress: {
            total_exercises: Exercise.count,
            completed_count: completed.count,
            in_progress_count: in_progress.count,
            completion_percentage: calculate_completion_percentage,
            total_points: current_user.total_points,
            level: current_user.level,
            level_progress: current_user.level_progress_percentage,
            points_to_next_level: current_user.points_to_next_level,
            current_streak: current_user.current_streak,
            longest_streak: current_user.longest_streak,
            completed_exercises: UserProgressSerializer.serialize_collection(completed),
            in_progress_exercises: UserProgressSerializer.serialize_collection(in_progress)
          }
        }
      end

      def achievements
        earned = current_user.user_achievements.includes(:achievement).order(earned_at: :desc)
        all_achievements = Achievement.ordered

        render json: {
          achievements: {
            earned_count: earned.count,
            total_count: all_achievements.count,
            earned: serialize_earned_achievements(earned),
            available: AchievementSerializer.serialize_collection(all_achievements, current_user: current_user)
          }
        }
      end

      private

      def serialize_earned_achievements(user_achievements)
        user_achievements.map do |ua|
          AchievementSerializer.serialize(ua.achievement, variant: :earned, user_achievement: ua)
        end
      end

      def calculate_completion_percentage
        total = Exercise.count
        return 0 if total.zero?

        completed = current_user.completed_exercises_count
        ((completed.to_f / total) * 100).round
      end
    end
  end
end
