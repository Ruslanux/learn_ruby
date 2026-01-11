require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin" do
    context "when not signed in" do
      it "redirects to sign in" do
        get admin_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as regular user" do
      let(:user) { create(:user, admin: false) }

      before { sign_in user }

      it "redirects to root with alert" do
        get admin_root_path
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include("/")
        expect(flash[:alert]).to be_present
      end
    end

    context "when signed in as admin" do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      it "returns success" do
        get admin_root_path
        expect(response).to have_http_status(:success)
      end

      it "displays dashboard statistics" do
        create_list(:user, 3)

        get admin_root_path

        expect(response.body).to include("Total Users")
        expect(response.body).to include("Total Submissions")
      end
    end
  end
end
