module Api
  module V1
    class LeaderboardController < BaseController
      include Paginatable

      def index
        @users = LeaderboardQuery.by_points(
          limit: (params[:limit] || 50).to_i,
          offset: params[:offset].to_i
        )

        @limit = (params[:limit] || 50).to_i
        @offset = params[:offset].to_i
        @total_count = LeaderboardQuery.total_count

        render json: {
          leaderboard: serialize_leaderboard(@users),
          current_user_rank: LeaderboardQuery.rank_for(current_user),
          pagination: pagination_meta
        }
      end

      def streaks
        @users = LeaderboardQuery.by_streak(limit: (params[:limit] || 50).to_i)

        @limit = (params[:limit] || 50).to_i
        @offset = 0
        @total_count = LeaderboardQuery.total_count

        render json: {
          leaderboard: serialize_streaks(@users),
          current_user: {
            rank: LeaderboardQuery.streak_rank_for(current_user),
            current_streak: current_user.current_streak,
            longest_streak: current_user.longest_streak
          },
          pagination: pagination_meta
        }
      end

      private

      def serialize_leaderboard(users)
        users.map.with_index(1) do |user, index|
          UserSerializer.serialize(user, variant: :leaderboard, rank: index + @offset, current_user: current_user)
        end
      end

      def serialize_streaks(users)
        users.map.with_index(1) do |user, rank|
          UserSerializer.serialize(user, variant: :streak, rank: rank, current_user: current_user)
        end
      end
    end
  end
end
