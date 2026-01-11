class LeaderboardController < ApplicationController
  def index
    @users = User.order(total_points: :desc, level: :desc)
                 .limit(50)
                 .select(:id, :username, :total_points, :level, :current_streak)

    @current_user_rank = current_user&.rank
  end
end
