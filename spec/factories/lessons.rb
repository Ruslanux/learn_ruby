FactoryBot.define do
  factory :lesson do
    sequence(:title) { |n| "Lesson #{n}" }
    description { "Learn Ruby concepts through hands-on exercises" }
    module_number { 1 }
    sequence(:position) { |n| n }
    difficulty { :beginner }
    ruby_version { "3.4" }

    trait :intermediate do
      difficulty { :intermediate }
      module_number { 2 }
    end

    trait :advanced do
      difficulty { :advanced }
      module_number { 3 }
    end

    trait :modern do
      difficulty { :modern }
      module_number { 4 }
    end
  end
end
