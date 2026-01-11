FactoryBot.define do
  factory :user_progress do
    user
    exercise
    status { :not_started }
    attempts { 0 }
    last_code { nil }
    completed_at { nil }
    points_earned { 0 }

    trait :in_progress do
      status { :in_progress }
      attempts { 3 }
      last_code { "def solution\n  'working on it'\nend" }
    end

    trait :completed do
      status { :completed }
      attempts { 5 }
      last_code { "def solution\n  'Hello!'\nend" }
      completed_at { Time.current }
      points_earned { 10 }
    end
  end
end
