require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      lesson = build(:lesson)
      expect(lesson).to be_valid
    end

    it "requires a title" do
      lesson = build(:lesson, title: nil)
      expect(lesson).not_to be_valid
    end

    it "requires a module_number" do
      lesson = build(:lesson, module_number: nil)
      expect(lesson).not_to be_valid
    end

    it "requires module_number to be positive" do
      lesson = build(:lesson, module_number: 0)
      expect(lesson).not_to be_valid
    end
  end

  describe "enums" do
    it "has correct difficulty values" do
      expect(Lesson.difficulties).to eq({
        "beginner" => 0,
        "intermediate" => 1,
        "advanced" => 2,
        "modern" => 3
      })
    end
  end

  describe "associations" do
    it "has many exercises" do
      lesson = create(:lesson)
      exercise = create(:exercise, lesson: lesson)
      expect(lesson.exercises).to include(exercise)
    end
  end

  describe "scopes" do
    it "orders by module_number and position" do
      lesson2 = create(:lesson, module_number: 2, position: 1)
      lesson1 = create(:lesson, module_number: 1, position: 2)
      lesson3 = create(:lesson, module_number: 1, position: 1)

      expect(Lesson.ordered).to eq([ lesson3, lesson1, lesson2 ])
    end
  end
end
