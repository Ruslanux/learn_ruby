FactoryBot.define do
  factory :code_submission do
    user
    exercise
    code { "def solution\n  'attempt'\nend" }
    result { "1 example, 1 failure" }
    passed { false }
    execution_time { 0.05 }

    trait :passed do
      code { "def solution\n  'Hello!'\nend" }
      result { "1 example, 0 failures" }
      passed { true }
    end
  end
end
