require 'rails_helper'

RSpec.describe "Profile", type: :request do
  describe "GET /profile" do
    context "when user is not signed in" do
      it "redirects to sign in page" do
        get profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      let(:user) { create(:user, username: "testprofile", total_points: 100, level: 2) }

      before { sign_in user }

      it "returns http success" do
        get profile_path
        expect(response).to have_http_status(:success)
      end

      it "displays user info" do
        get profile_path

        expect(response.body).to include(user.username)
        expect(response.body).to include("Level 2")
      end

      it "displays completed exercises" do
        lesson = create(:lesson)
        exercise = create(:exercise, lesson: lesson, title: "Test Exercise")
        create(:user_progress, user: user, exercise: exercise, status: :completed)

        get profile_path

        expect(response.body).to include("Test Exercise")
      end

      it "displays user achievements" do
        achievement = create(:achievement, name: "First Steps", badge_icon: "🎯")
        create(:user_achievement, user: user, achievement: achievement)

        get profile_path

        expect(response.body).to include("First Steps")
      end
    end
  end
end
