# frozen_string_literal: true

class LeaderboardQuery < BaseQuery
  DEFAULT_LIMIT = 50

  def initialize(relation = default_relation, limit: DEFAULT_LIMIT, offset: 0)
    super(relation)
    @limit = limit
    @offset = offset
  end

  def call
    relation.where(admin: false)
            .order(total_points: :desc, level: :desc)
            .offset(@offset)
            .limit(@limit)
  end

  def self.by_points(limit: DEFAULT_LIMIT, offset: 0)
    new(limit: limit, offset: offset).call
  end

  def self.by_streak(limit: DEFAULT_LIMIT)
    new.by_streak(limit)
  end

  def by_streak(limit = DEFAULT_LIMIT)
    relation.where(admin: false)
            .where("longest_streak > 0")
            .order(longest_streak: :desc, current_streak: :desc)
            .limit(limit)
  end

  def self.rank_for(user)
    User.where(admin: false).where("total_points > ?", user.total_points).count + 1
  end

  def self.streak_rank_for(user)
    User.where(admin: false).where("longest_streak > ?", user.longest_streak).count + 1
  end

  def self.total_count
    User.where(admin: false).count
  end

  private

  def default_relation
    User.all
  end
end
