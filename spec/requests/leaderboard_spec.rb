require 'rails_helper'

RSpec.describe "Leaderboard", type: :request do
  describe "GET /leaderboard" do
    it "returns http success" do
      get leaderboard_path
      expect(response).to have_http_status(:success)
    end

    it "displays users ordered by total_points descending" do
      user1 = create(:user, username: "user1", total_points: 100)
      user2 = create(:user, username: "user2", total_points: 300)
      user3 = create(:user, username: "user3", total_points: 200)

      get leaderboard_path

      expect(response.body).to match(/user2.*user3.*user1/m)
    end

    context "when user is signed in" do
      let(:user) { create(:user, total_points: 150) }

      before { sign_in user }

      it "highlights the current user's row" do
        create(:user, total_points: 200)
        create(:user, total_points: 100)

        get leaderboard_path

        # The leaderboard shows "You" indicator for current user
        expect(response.body).to include("You")
      end
    end
  end
end
