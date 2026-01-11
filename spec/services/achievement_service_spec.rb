require 'rails_helper'

RSpec.describe AchievementService do
  let(:user) { create(:user) }

  describe "#check_and_award_all" do
    context "with points-based achievements" do
      let!(:achievement) { create(:achievement, :points_based, points_required: 100) }

      it "awards achievement when user meets points requirement" do
        user.update!(total_points: 100)
        service = described_class.new(user)

        expect { service.check_and_award_all }.to change { user.achievements.count }.by(1)
        expect(user.achievements).to include(achievement)
      end

      it "does not award achievement when user doesn't meet requirement" do
        user.update!(total_points: 50)
        service = described_class.new(user)

        expect { service.check_and_award_all }.not_to change { user.achievements.count }
      end

      it "does not award same achievement twice" do
        user.update!(total_points: 100)
        create(:user_achievement, user: user, achievement: achievement)
        service = described_class.new(user)

        expect { service.check_and_award_all }.not_to change { user.achievements.count }
      end
    end

    context "with exercises-based achievements" do
      let!(:achievement) { create(:achievement, :exercises_based, exercises_required: 3) }

      it "awards achievement when user completes enough exercises" do
        3.times do
          exercise = create(:exercise)
          create(:user_progress, user: user, exercise: exercise, status: :completed)
        end
        service = described_class.new(user)

        expect { service.check_and_award_all }.to change { user.achievements.count }.by(1)
        expect(user.achievements).to include(achievement)
      end
    end

    context "with streak-based achievements" do
      let!(:achievement) { create(:achievement, :streak_based, streak_required: 5) }

      it "awards achievement when user has long enough streak" do
        user.update!(longest_streak: 5)
        service = described_class.new(user)

        expect { service.check_and_award_all }.to change { user.achievements.count }.by(1)
        expect(user.achievements).to include(achievement)
      end
    end
  end

  describe "#award" do
    let(:achievement) { create(:achievement) }

    it "awards the achievement to the user" do
      service = described_class.new(user)

      expect { service.award(achievement) }.to change { user.achievements.count }.by(1)
    end

    it "adds the achievement to newly_earned" do
      service = described_class.new(user)
      service.award(achievement)

      expect(service.newly_earned).to include(achievement)
    end

    it "returns false if user already has the achievement" do
      create(:user_achievement, user: user, achievement: achievement)
      service = described_class.new(user)

      expect(service.award(achievement)).to be false
    end

    it "does not duplicate achievements" do
      create(:user_achievement, user: user, achievement: achievement)
      service = described_class.new(user)

      expect { service.award(achievement) }.not_to change { user.achievements.count }
    end
  end

  describe "#newly_earned" do
    it "returns empty array initially" do
      service = described_class.new(user)
      expect(service.newly_earned).to eq([])
    end

    it "accumulates awarded achievements" do
      achievement1 = create(:achievement, :points_based, points_required: 10)
      achievement2 = create(:achievement, :points_based, points_required: 20)
      user.update!(total_points: 50)

      service = described_class.new(user)
      service.check_and_award_all

      expect(service.newly_earned).to contain_exactly(achievement1, achievement2)
    end
  end
end
