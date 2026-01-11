# frozen_string_literal: true

require "rails_helper"

RSpec.describe AchievementCheckJob, type: :job do
  let(:user) { create(:user) }

  describe "#perform" do
    it "calls AchievementService#check_and_award_all" do
      service_double = instance_double(AchievementService, check_and_award_all: [])
      allow(AchievementService).to receive(:new).with(user).and_return(service_double)

      AchievementCheckJob.perform_now(user.id)

      expect(service_double).to have_received(:check_and_award_all)
    end
  end

  describe "queue" do
    it "is enqueued to default queue" do
      expect {
        AchievementCheckJob.perform_later(user.id)
      }.to have_enqueued_job(AchievementCheckJob).on_queue("default")
    end
  end
end
