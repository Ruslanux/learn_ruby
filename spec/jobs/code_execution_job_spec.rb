# frozen_string_literal: true

require "rails_helper"

RSpec.describe CodeExecutionJob, type: :job do
  let(:user) { create(:user, total_points: 0) }
  let(:lesson) { create(:lesson) }
  let(:exercise) { create(:exercise, lesson: lesson, points: 20) }
  let(:submission) { create(:code_submission, user: user, exercise: exercise, code: "def hello; 'Hello!'; end") }

  describe "#perform" do
    before do
      allow_any_instance_of(RubySandboxService).to receive(:execute).and_return(
        RubySandboxService::Result.new(
          success: true,
          output: "All tests passed",
          errors: "",
          test_results: [ { name: "test", passed: true } ],
          execution_time: 0.5
        )
      )
      # Prevent achievement checking from interfering
      allow(AchievementCheckJob).to receive(:perform_later)
    end

    it "executes code and updates submission" do
      CodeExecutionJob.perform_now(submission.id)

      submission.reload
      expect(submission.result).to eq("All tests passed")
      expect(submission.passed).to be true
      expect(submission.execution_time).to eq(0.5)
    end

    it "updates user progress on success" do
      CodeExecutionJob.perform_now(submission.id)

      progress = UserProgress.find_by(user: user, exercise: exercise)
      expect(progress).to be_present
      expect(progress.status).to eq("completed")
      expect(progress.points_earned).to eq(20)
    end

    it "awards points to user on first completion" do
      CodeExecutionJob.perform_now(submission.id)

      expect(user.reload.total_points).to eq(20)
    end

    it "does not award points on subsequent completions" do
      create(:user_progress, user: user, exercise: exercise, status: :completed, points_earned: 20)
      user.update!(total_points: 20)

      CodeExecutionJob.perform_now(submission.id)

      expect(user.reload.total_points).to eq(20)
    end

    context "when execution fails" do
      before do
        allow_any_instance_of(RubySandboxService).to receive(:execute).and_return(
          RubySandboxService::Result.new(
            success: false,
            output: "",
            errors: "Test failed",
            test_results: [ { name: "test", passed: false } ],
            execution_time: 0.3
          )
        )
      end

      it "updates submission with failure" do
        CodeExecutionJob.perform_now(submission.id)

        submission.reload
        expect(submission.result).to eq("Test failed")
        expect(submission.passed).to be false
      end

      it "does not update user progress" do
        CodeExecutionJob.perform_now(submission.id)

        progress = UserProgress.find_by(user: user, exercise: exercise)
        expect(progress).to be_nil
      end
    end
  end

  describe "queue" do
    it "is enqueued to code_execution queue" do
      expect {
        CodeExecutionJob.perform_later(submission.id)
      }.to have_enqueued_job(CodeExecutionJob).on_queue("code_execution")
    end
  end
end
