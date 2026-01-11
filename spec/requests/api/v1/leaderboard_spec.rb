require 'rails_helper'

RSpec.describe "Api::V1::Leaderboard", type: :request do
  let(:user) { create(:user, total_points: 100) }

  describe "GET /api/v1/leaderboard" do
    it "requires authentication" do
      get "/api/v1/leaderboard"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      before do
        create(:user, total_points: 200)
        create(:user, total_points: 50)
      end

      it "returns leaderboard ordered by points" do
        get "/api/v1/leaderboard", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["leaderboard"]).to be_an(Array)

        points = json_response["leaderboard"].map { |u| u["total_points"] }
        expect(points).to eq(points.sort.reverse)
      end

      it "includes current user rank" do
        get "/api/v1/leaderboard", headers: auth_headers(user)

        expect(json_response["current_user_rank"]).to be_present
      end

      it "supports pagination" do
        get "/api/v1/leaderboard", params: { limit: 1, offset: 1 }, headers: auth_headers(user)

        expect(json_response["leaderboard"].length).to eq(1)
      end
    end
  end

  describe "GET /api/v1/leaderboard/streaks" do
    it "requires authentication" do
      get "/api/v1/leaderboard/streaks"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      before do
        create(:user, longest_streak: 10, current_streak: 5)
        create(:user, longest_streak: 5, current_streak: 3)
      end

      it "returns streak leaderboard" do
        get "/api/v1/leaderboard/streaks", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["leaderboard"]).to be_an(Array)
      end

      it "orders by longest streak" do
        get "/api/v1/leaderboard/streaks", headers: auth_headers(user)

        streaks = json_response["leaderboard"].map { |u| u["longest_streak"] }
        expect(streaks).to eq(streaks.sort.reverse)
      end
    end
  end
end
