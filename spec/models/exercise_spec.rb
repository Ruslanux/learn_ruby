require 'rails_helper'

RSpec.describe Exercise, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      exercise = build(:exercise)
      expect(exercise).to be_valid
    end

    it "requires a title" do
      exercise = build(:exercise, title: nil)
      expect(exercise).not_to be_valid
    end

    it "requires test_code" do
      exercise = build(:exercise, test_code: nil)
      expect(exercise).not_to be_valid
    end

    it "requires points to be positive" do
      exercise = build(:exercise, points: 0)
      expect(exercise).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a lesson" do
      lesson = create(:lesson)
      exercise = create(:exercise, lesson: lesson)
      expect(exercise.lesson).to eq(lesson)
    end
  end

  describe "delegation" do
    it "delegates difficulty to lesson" do
      lesson = create(:lesson, difficulty: :advanced)
      exercise = create(:exercise, lesson: lesson)
      expect(exercise.difficulty).to eq("advanced")
    end

    it "delegates module_number to lesson" do
      lesson = create(:lesson, module_number: 3)
      exercise = create(:exercise, lesson: lesson)
      expect(exercise.module_number).to eq(3)
    end
  end
end
