# frozen_string_literal: true

require "rails_helper"

RSpec.describe StreakUpdateJob, type: :job do
  let(:user) { create(:user, current_streak: 0, last_activity_date: nil) }

  describe "#perform" do
    it "updates user streak" do
      expect {
        StreakUpdateJob.perform_now(user.id)
      }.to change { user.reload.current_streak }.from(0).to(1)
    end

    it "sets last_activity_date" do
      StreakUpdateJob.perform_now(user.id)

      expect(user.reload.last_activity_date).to eq(Date.current)
    end
  end

  describe "queue" do
    it "is enqueued to default queue" do
      expect {
        StreakUpdateJob.perform_later(user.id)
      }.to have_enqueued_job(StreakUpdateJob).on_queue("default")
    end
  end
end
