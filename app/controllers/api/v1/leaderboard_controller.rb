module Api
  module V1
    class LeaderboardController < BaseController
      def index
        offset = (params[:offset] || 0).to_i
        @users = User.where(admin: false)
                     .order(total_points: :desc, level: :desc)
                     .limit(params[:limit] || 50)
                     .offset(offset)

        render json: {
          leaderboard: serialize_leaderboard(@users, offset),
          current_user_rank: current_user.rank,
          total_users: User.where(admin: false).count
        }
      end

      def streaks
        @users = User.where(admin: false)
                     .where("longest_streak > 0")
                     .order(longest_streak: :desc, current_streak: :desc)
                     .limit(params[:limit] || 50)

        render json: {
          leaderboard: serialize_streaks(@users),
          current_user: {
            rank: streak_rank(current_user),
            current_streak: current_user.current_streak,
            longest_streak: current_user.longest_streak
          }
        }
      end

      private

      def serialize_leaderboard(users, offset)
        users.map.with_index(1) do |user, index|
          UserSerializer.serialize(user, variant: :leaderboard, rank: index + offset, current_user: current_user)
        end
      end

      def serialize_streaks(users)
        users.map.with_index(1) do |user, rank|
          UserSerializer.serialize(user, variant: :streak, rank: rank, current_user: current_user)
        end
      end

      def streak_rank(user)
        User.where(admin: false).where("longest_streak > ?", user.longest_streak).count + 1
      end
    end
  end
end
