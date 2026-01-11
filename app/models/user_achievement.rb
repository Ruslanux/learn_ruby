class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  validates :user_id, uniqueness: { scope: :achievement_id }
  validates :earned_at, presence: true

  default_scope { order(earned_at: :desc) }
  scope :recent, -> { order(earned_at: :desc) }
end
