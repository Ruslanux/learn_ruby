module Api
  module V1
    class UsersController < BaseController
      def me
        render json: {
          user: user_json(current_user)
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
            completed_exercises: completed.map { |p| progress_json(p) },
            in_progress_exercises: in_progress.map { |p| progress_json(p) }
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
            earned: earned.map { |ua| earned_achievement_json(ua) },
            available: all_achievements.map { |a| achievement_json(a) }
          }
        }
      end

      private

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          username: user.username,
          level: user.level,
          total_points: user.total_points,
          current_streak: user.current_streak,
          longest_streak: user.longest_streak,
          rank: user.rank,
          level_progress: user.level_progress_percentage,
          points_to_next_level: user.points_to_next_level,
          completed_exercises_count: user.completed_exercises_count,
          achievements_count: user.achievements.count,
          created_at: user.created_at
        }
      end

      def progress_json(progress)
        {
          exercise_id: progress.exercise.id,
          exercise_title: progress.exercise.title,
          lesson_title: progress.exercise.lesson.title,
          status: progress.status,
          attempts: progress.attempts,
          points_earned: progress.points_earned,
          completed_at: progress.completed_at
        }
      end

      def earned_achievement_json(user_achievement)
        {
          id: user_achievement.achievement.id,
          name: user_achievement.achievement.name,
          description: user_achievement.achievement.description,
          badge_icon: user_achievement.achievement.badge_icon,
          category: user_achievement.achievement.category,
          earned_at: user_achievement.earned_at
        }
      end

      def achievement_json(achievement)
        earned = current_user.has_achievement?(achievement)

        {
          id: achievement.id,
          name: achievement.name,
          description: achievement.description,
          badge_icon: achievement.badge_icon,
          category: achievement.category,
          earned: earned,
          requirement_met: achievement.requirement_met?(current_user)
        }
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
