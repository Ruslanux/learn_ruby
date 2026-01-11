require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      achievement = build(:achievement)
      expect(achievement).to be_valid
    end

    it "requires a name" do
      achievement = build(:achievement, name: nil)
      expect(achievement).not_to be_valid
    end

    it "requires a unique name" do
      create(:achievement, name: "Test Achievement")
      achievement = build(:achievement, name: "Test Achievement")
      expect(achievement).not_to be_valid
    end

    it "requires a description" do
      achievement = build(:achievement, description: nil)
      expect(achievement).not_to be_valid
    end

    it "requires a badge_icon" do
      achievement = build(:achievement, badge_icon: nil)
      expect(achievement).not_to be_valid
    end

    it "requires a category" do
      achievement = build(:achievement, category: nil)
      expect(achievement).not_to be_valid
    end
  end

  describe "associations" do
    it "has many user_achievements" do
      achievement = create(:achievement)
      user = create(:user)
      create(:user_achievement, user: user, achievement: achievement)

      expect(achievement.user_achievements.count).to eq(1)
    end

    it "has many users through user_achievements" do
      achievement = create(:achievement)
      user = create(:user)
      create(:user_achievement, user: user, achievement: achievement)

      expect(achievement.users).to include(user)
    end

    it "destroys user_achievements when destroyed" do
      achievement = create(:achievement)
      user = create(:user)
      create(:user_achievement, user: user, achievement: achievement)

      expect { achievement.destroy }.to change { UserAchievement.count }.by(-1)
    end
  end

  describe "#earned_by?" do
    let(:user) { create(:user) }
    let(:achievement) { create(:achievement) }

    it "returns false when user hasn't earned achievement" do
      expect(achievement.earned_by?(user)).to be false
    end

    it "returns true when user has earned achievement" do
      create(:user_achievement, user: user, achievement: achievement)
      expect(achievement.earned_by?(user)).to be true
    end
  end

  describe "#requirement_met?" do
    let(:user) { create(:user) }

    context "with points-based achievement" do
      let(:achievement) { create(:achievement, :points_based, points_required: 100) }

      it "returns false when user doesn't have enough points" do
        user.update!(total_points: 50)
        expect(achievement.requirement_met?(user)).to be false
      end

      it "returns true when user has enough points" do
        user.update!(total_points: 100)
        expect(achievement.requirement_met?(user)).to be true
      end
    end

    context "with exercises-based achievement" do
      let(:achievement) { create(:achievement, :exercises_based, exercises_required: 3) }

      it "returns false when user hasn't completed enough exercises" do
        expect(achievement.requirement_met?(user)).to be false
      end

      it "returns true when user has completed enough exercises" do
        3.times do
          exercise = create(:exercise)
          create(:user_progress, user: user, exercise: exercise, status: :completed)
        end
        expect(achievement.requirement_met?(user)).to be true
      end
    end

    context "with streak-based achievement" do
      let(:achievement) { create(:achievement, :streak_based, streak_required: 5) }

      it "returns false when user doesn't have long enough streak" do
        user.update!(longest_streak: 3)
        expect(achievement.requirement_met?(user)).to be false
      end

      it "returns true when user has long enough streak" do
        user.update!(longest_streak: 5)
        expect(achievement.requirement_met?(user)).to be true
      end
    end
  end
end
