require 'rails_helper'

RSpec.describe UserAchievement, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user_achievement = build(:user_achievement)
      expect(user_achievement).to be_valid
    end

    it "requires earned_at" do
      user_achievement = build(:user_achievement, earned_at: nil)
      expect(user_achievement).not_to be_valid
    end

    it "validates uniqueness of achievement scoped to user" do
      user = create(:user)
      achievement = create(:achievement)
      create(:user_achievement, user: user, achievement: achievement)

      duplicate = build(:user_achievement, user: user, achievement: achievement)
      expect(duplicate).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      user_achievement = create(:user_achievement)
      expect(user_achievement.user).to be_present
    end

    it "belongs to achievement" do
      user_achievement = create(:user_achievement)
      expect(user_achievement.achievement).to be_present
    end
  end

  describe "default scope" do
    it "orders by earned_at descending" do
      user = create(:user)
      old_achievement = create(:user_achievement, user: user, earned_at: 2.days.ago)
      new_achievement = create(:user_achievement, user: user, earned_at: 1.hour.ago)

      expect(user.user_achievements.to_a).to eq([new_achievement, old_achievement])
    end
  end
end
