module Api
  module V1
    class LeaderboardController < BaseController
      def index
        @users = User.order(total_points: :desc, level: :desc)
                     .limit(params[:limit] || 50)
                     .offset(params[:offset] || 0)

        render json: {
          leaderboard: @users.map.with_index(1) { |user, rank| leaderboard_entry(user, rank + (params[:offset] || 0).to_i) },
          current_user_rank: current_user.rank,
          total_users: User.count
        }
      end

      def streaks
        @users = User.where("longest_streak > 0")
                     .order(longest_streak: :desc, current_streak: :desc)
                     .limit(params[:limit] || 50)

        render json: {
          leaderboard: @users.map.with_index(1) { |user, rank| streak_entry(user, rank) },
          current_user: {
            rank: streak_rank(current_user),
            current_streak: current_user.current_streak,
            longest_streak: current_user.longest_streak
          }
        }
      end

      private

      def leaderboard_entry(user, rank)
        {
          rank: rank,
          id: user.id,
          username: user.username,
          level: user.level,
          total_points: user.total_points,
          current_streak: user.current_streak,
          is_current_user: user.id == current_user.id
        }
      end

      def streak_entry(user, rank)
        {
          rank: rank,
          id: user.id,
          username: user.username,
          current_streak: user.current_streak,
          longest_streak: user.longest_streak,
          is_current_user: user.id == current_user.id
        }
      end

      def streak_rank(user)
        User.where("longest_streak > ?", user.longest_streak).count + 1
      end
    end
  end
end
