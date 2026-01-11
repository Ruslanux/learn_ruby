require 'rails_helper'

RSpec.describe CodeSubmission, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      submission = build(:code_submission)
      expect(submission).to be_valid
    end

    it "requires code" do
      submission = build(:code_submission, code: nil)
      expect(submission).not_to be_valid
    end
  end

  describe "scopes" do
    let(:exercise) { create(:exercise) }

    it "filters passed submissions" do
      passed = create(:code_submission, :passed, exercise: exercise)
      failed = create(:code_submission, exercise: exercise)

      expect(CodeSubmission.passed).to include(passed)
      expect(CodeSubmission.passed).not_to include(failed)
    end

    it "filters failed submissions" do
      passed = create(:code_submission, :passed, exercise: exercise)
      failed = create(:code_submission, exercise: exercise)

      expect(CodeSubmission.failed).to include(failed)
      expect(CodeSubmission.failed).not_to include(passed)
    end

    it "orders by recent" do
      old = create(:code_submission, exercise: exercise)
      new = create(:code_submission, exercise: exercise)

      expect(CodeSubmission.recent.first).to eq(new)
    end
  end
end
