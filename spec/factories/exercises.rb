FactoryBot.define do
  factory :exercise do
    lesson
    sequence(:title) { |n| "Exercise #{n}" }
    description { "Learn a Ruby concept" }
    instructions { "Write code that passes the tests" }
    hints { [ "Think about the problem", "Check the documentation" ] }
    starter_code { "def solution\n  # Your code here\nend" }
    solution_code { "def solution\n  'Hello!'\nend" }
    test_code { "RSpec.describe 'solution' do\n  it 'works' do\n    expect(solution).to eq('Hello!')\n  end\nend" }
    topics { [ "basics", "functions" ] }
    points { 10 }
    sequence(:position) { |n| n }
  end
end
