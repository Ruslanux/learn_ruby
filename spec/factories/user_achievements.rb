FactoryBot.define do
  factory :user_achievement do
    user
    achievement
    earned_at { Time.current }
  end
end
