class UserSerializer < ApplicationSerializer
  def as_json
    case options[:variant]
    when :minimal
      minimal_json
    when :auth
      auth_json
    when :leaderboard
      leaderboard_json
    when :streak
      streak_json
    else
      full_json
    end
  end

  private

  def minimal_json
    {
      id: object.id,
      username: object.username,
      level: object.level,
      total_points: object.total_points
    }
  end

  def auth_json
    {
      id: object.id,
      email: object.email,
      username: object.username,
      level: object.level,
      total_points: object.total_points,
      current_streak: object.current_streak
    }
  end

  def full_json
    {
      id: object.id,
      email: object.email,
      username: object.username,
      level: object.level,
      total_points: object.total_points,
      current_streak: object.current_streak,
      longest_streak: object.longest_streak,
      rank: object.rank,
      level_progress: object.level_progress_percentage,
      points_to_next_level: object.points_to_next_level,
      completed_exercises_count: object.completed_exercises_count,
      achievements_count: object.achievements.count,
      created_at: object.created_at
    }
  end

  def leaderboard_json
    {
      rank: options[:rank],
      id: object.id,
      username: object.username,
      level: object.level,
      total_points: object.total_points,
      current_streak: object.current_streak,
      is_current_user: current_user && object.id == current_user.id
    }
  end

  def streak_json
    {
      rank: options[:rank],
      id: object.id,
      username: object.username,
      current_streak: object.current_streak,
      longest_streak: object.longest_streak,
      is_current_user: current_user && object.id == current_user.id
    }
  end
end
