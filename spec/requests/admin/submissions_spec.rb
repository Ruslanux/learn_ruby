require 'rails_helper'

RSpec.describe "Admin::Submissions", type: :request do
  let(:admin) { create(:user, admin: true) }

  before { sign_in admin }

  describe "GET /admin/submissions" do
    it "returns success" do
      get admin_submissions_path
      expect(response).to have_http_status(:success)
    end

    it "lists submissions" do
      exercise = create(:exercise)
      user = create(:user)
      submission = create(:code_submission, user: user, exercise: exercise, passed: true)

      get admin_submissions_path

      expect(response.body).to include(user.username)
    end

    it "filters by passed" do
      exercise = create(:exercise)
      user = create(:user)
      create(:code_submission, user: user, exercise: exercise, passed: true)
      create(:code_submission, user: user, exercise: exercise, passed: false)

      get admin_submissions_path, params: { filter: "passed" }

      expect(response.body).to include("Passed")
    end
  end

  describe "GET /admin/submissions/:id" do
    let(:submission) { create(:code_submission) }

    it "returns success" do
      get admin_submission_path(submission)
      expect(response).to have_http_status(:success)
    end

    it "shows submission details" do
      get admin_submission_path(submission)
      expect(response.body).to include("Submitted Code")
    end
  end
end
