require 'rails_helper'

RSpec.describe UserProgress, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      progress = build(:user_progress)
      expect(progress).to be_valid
    end

    it "requires unique user/exercise combination" do
      progress = create(:user_progress)
      duplicate = build(:user_progress, user: progress.user, exercise: progress.exercise)
      expect(duplicate).not_to be_valid
    end
  end

  describe "enums" do
    it "has correct status values" do
      expect(UserProgress.statuses).to eq({
        "not_started" => 0,
        "in_progress" => 1,
        "completed" => 2
      })
    end
  end

  describe "#complete!" do
    it "marks progress as completed with points" do
      progress = create(:user_progress, :in_progress)

      progress.complete!(15)

      expect(progress).to be_completed
      expect(progress.points_earned).to eq(15)
      expect(progress.completed_at).to be_present
    end

    it "uses exercise points if not specified" do
      exercise = create(:exercise, points: 20)
      progress = create(:user_progress, exercise: exercise)

      progress.complete!

      expect(progress.points_earned).to eq(20)
    end
  end

  describe "#increment_attempts!" do
    it "increases attempts count" do
      progress = create(:user_progress, attempts: 0)

      expect { progress.increment_attempts! }.to change { progress.attempts }.by(1)
    end

    it "changes status to in_progress if not_started" do
      progress = create(:user_progress, status: :not_started)

      progress.increment_attempts!

      expect(progress).to be_in_progress
    end
  end
end
