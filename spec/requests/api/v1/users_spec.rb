require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user, total_points: 100, level: 2) }

  describe "GET /api/v1/users/me" do
    it "requires authentication" do
      get "/api/v1/users/me"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "returns current user info" do
        get "/api/v1/users/me", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["user"]["username"]).to eq(user.username)
        expect(json_response["user"]["level"]).to eq(2)
        expect(json_response["user"]["total_points"]).to eq(100)
      end
    end
  end

  describe "GET /api/v1/users/me/progress" do
    it "requires authentication" do
      get "/api/v1/users/me/progress"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      let(:lesson) { create(:lesson) }
      let(:exercise) { create(:exercise, lesson: lesson) }

      before do
        create(:user_progress, user: user, exercise: exercise, status: :completed)
      end

      it "returns progress information" do
        get "/api/v1/users/me/progress", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["progress"]).to include(
          "total_exercises",
          "completed_count",
          "completion_percentage"
        )
      end

      it "includes completed exercises" do
        get "/api/v1/users/me/progress", headers: auth_headers(user)

        expect(json_response["progress"]["completed_exercises"]).to be_an(Array)
      end
    end
  end

  describe "GET /api/v1/users/me/achievements" do
    it "requires authentication" do
      get "/api/v1/users/me/achievements"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      let!(:achievement) { create(:achievement) }

      before do
        create(:user_achievement, user: user, achievement: achievement)
      end

      it "returns achievements" do
        get "/api/v1/users/me/achievements", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["achievements"]["earned_count"]).to eq(1)
        expect(json_response["achievements"]["earned"]).to be_an(Array)
      end
    end
  end
end
