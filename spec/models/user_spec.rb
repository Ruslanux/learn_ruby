require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires a username" do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    it "requires a unique username" do
      create(:user, username: "testuser")
      user = build(:user, username: "testuser")
      expect(user).not_to be_valid
    end

    it "requires username to be at least 3 characters" do
      user = build(:user, username: "ab")
      expect(user).not_to be_valid
    end

    it "requires username to only contain letters, numbers, and underscores" do
      user = build(:user, username: "test user!")
      expect(user).not_to be_valid
    end
  end

  describe "defaults" do
    it "sets level to 1 by default" do
      user = create(:user)
      expect(user.level).to eq(1)
    end

    it "sets total_points to 0 by default" do
      user = create(:user)
      expect(user.total_points).to eq(0)
    end

    it "sets current_streak to 0 by default" do
      user = create(:user)
      expect(user.current_streak).to eq(0)
    end

    it "sets longest_streak to 0 by default" do
      user = create(:user)
      expect(user.longest_streak).to eq(0)
    end
  end

  describe "associations" do
    it "has many user_achievements" do
      user = create(:user)
      achievement = create(:achievement)
      create(:user_achievement, user: user, achievement: achievement)

      expect(user.user_achievements.count).to eq(1)
    end

    it "has many achievements through user_achievements" do
      user = create(:user)
      achievement = create(:achievement)
      create(:user_achievement, user: user, achievement: achievement)

      expect(user.achievements).to include(achievement)
    end

    it "destroys user_achievements when destroyed" do
      user = create(:user)
      achievement = create(:achievement)
      create(:user_achievement, user: user, achievement: achievement)

      expect { user.destroy }.to change { UserAchievement.count }.by(-1)
    end
  end

  describe "#add_points!" do
    let(:user) { create(:user, total_points: 0) }

    it "increments total_points" do
      expect { user.add_points!(10) }.to change { user.total_points }.by(10)
    end

    it "updates streak" do
      user.add_points!(10)
      expect(user.current_streak).to eq(1)
    end
  end

  describe "#update_streak!" do
    let(:user) { create(:user, current_streak: 0, longest_streak: 0, last_activity_date: nil) }

    context "when first activity" do
      it "sets streak to 1" do
        user.update_streak!
        expect(user.current_streak).to eq(1)
        expect(user.longest_streak).to eq(1)
      end
    end

    context "when continuing streak (consecutive day)" do
      before do
        user.update!(current_streak: 3, longest_streak: 3, last_activity_date: Date.current - 1)
      end

      it "increments streak" do
        user.update_streak!
        expect(user.current_streak).to eq(4)
        expect(user.longest_streak).to eq(4)
      end
    end

    context "when activity on same day" do
      before do
        user.update!(current_streak: 3, longest_streak: 3, last_activity_date: Date.current)
      end

      it "does not change streak" do
        user.update_streak!
        expect(user.current_streak).to eq(3)
      end
    end

    context "when streak broken (skipped a day)" do
      before do
        user.update!(current_streak: 5, longest_streak: 5, last_activity_date: Date.current - 3)
      end

      it "resets current streak to 1" do
        user.update_streak!
        expect(user.current_streak).to eq(1)
      end

      it "keeps longest streak" do
        user.update_streak!
        expect(user.longest_streak).to eq(5)
      end
    end
  end

  describe "level updates via add_points!" do
    let(:user) { create(:user, total_points: 0, level: 1) }

    it "updates level based on points" do
      user.add_points!(50)
      expect(user.level).to eq(2)
    end

    it "handles multiple level ups" do
      user.add_points!(500)
      expect(user.level).to eq(5)
    end

    it "caps at max level" do
      user.add_points!(10000)
      expect(user.level).to eq(User::LEVEL_THRESHOLDS.length)
    end
  end

  describe "#level_progress_percentage" do
    let(:user) { create(:user, level: 1, total_points: 25) }

    it "returns percentage towards next level" do
      expect(user.level_progress_percentage).to eq(50)
    end

    it "returns 100 at max level" do
      user.update!(level: User::LEVEL_THRESHOLDS.length, total_points: 10000)
      expect(user.level_progress_percentage).to eq(100)
    end
  end

  describe "#points_to_next_level" do
    let(:user) { create(:user, level: 1, total_points: 25) }

    it "returns points needed for next level" do
      expect(user.points_to_next_level).to eq(25)  # 50 - 25 = 25
    end

    it "returns 0 at max level" do
      user.update!(level: User::LEVEL_THRESHOLDS.length, total_points: 10000)
      expect(user.points_to_next_level).to eq(0)
    end
  end

  describe "#completed_exercises_count" do
    let(:user) { create(:user) }

    it "returns count of completed exercises" do
      exercise1 = create(:exercise)
      exercise2 = create(:exercise)
      create(:user_progress, user: user, exercise: exercise1, status: :completed)
      create(:user_progress, user: user, exercise: exercise2, status: :in_progress)

      expect(user.completed_exercises_count).to eq(1)
    end
  end

  describe "#has_achievement?" do
    let(:user) { create(:user) }
    let(:achievement) { create(:achievement) }

    it "returns false when user doesn't have achievement" do
      expect(user.has_achievement?(achievement)).to be false
    end

    it "returns true when user has achievement" do
      create(:user_achievement, user: user, achievement: achievement)
      expect(user.has_achievement?(achievement)).to be true
    end
  end

  describe "#rank" do
    it "returns user's rank based on total_points" do
      user1 = create(:user, total_points: 100)
      user2 = create(:user, total_points: 300)
      user3 = create(:user, total_points: 200)

      expect(user2.rank).to eq(1)
      expect(user3.rank).to eq(2)
      expect(user1.rank).to eq(3)
    end
  end
end
