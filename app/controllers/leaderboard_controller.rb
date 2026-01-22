class LeaderboardController < ApplicationController
  def index
    @users = LeaderboardQuery.by_points.select(:id, :username, :total_points, :level, :current_streak)
    @current_user_rank = current_user ? LeaderboardQuery.rank_for(current_user) : nil
  end
end
