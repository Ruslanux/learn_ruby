FactoryBot.define do
  factory :achievement do
    sequence(:name) { |n| "Achievement #{n}" }
    description { "Complete a challenge" }
    badge_icon { "🏆" }
    category { :points }
    points_required { 10 }

    trait :points_based do
      category { :points }
      points_required { 100 }
    end

    trait :exercises_based do
      category { :exercises }
      exercises_required { 5 }
      points_required { 0 }
    end

    trait :streak_based do
      category { :streak }
      streak_required { 3 }
      points_required { 0 }
    end

    trait :special do
      category { :special }
      points_required { 0 }
    end
  end
end
