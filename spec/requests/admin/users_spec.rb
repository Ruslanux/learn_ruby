require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, admin: true) }

  before { sign_in admin }

  describe "GET /admin/users" do
    it "returns success" do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end

    it "lists all users" do
      user = create(:user, username: "testuser123")

      get admin_users_path

      expect(response.body).to include("testuser123")
    end

    it "supports search" do
      create(:user, username: "findme")
      create(:user, username: "dontfind")

      get admin_users_path, params: { search: "findme" }

      expect(response.body).to include("findme")
      expect(response.body).not_to include("dontfind")
    end
  end

  describe "GET /admin/users/:id" do
    let(:user) { create(:user) }

    it "returns success" do
      get admin_user_path(user)
      expect(response).to have_http_status(:success)
    end

    it "shows user details" do
      get admin_user_path(user)
      expect(response.body).to include(user.username)
    end
  end

  describe "GET /admin/users/:id/edit" do
    let(:user) { create(:user) }

    it "returns success" do
      get edit_admin_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/users/:id" do
    let(:user) { create(:user) }

    it "updates the user" do
      patch admin_user_path(user), params: { user: { username: "newname" } }
      expect(user.reload.username).to eq("newname")
    end
  end

  describe "POST /admin/users/:id/toggle_admin" do
    context "with another user" do
      let(:user) { create(:user, admin: false) }

      it "grants admin access" do
        post toggle_admin_admin_user_path(user)
        expect(user.reload.admin?).to be true
      end

      it "revokes admin access" do
        user.update!(admin: true)
        post toggle_admin_admin_user_path(user)
        expect(user.reload.admin?).to be false
      end
    end

    context "with self" do
      it "does not allow changing own admin status" do
        post toggle_admin_admin_user_path(admin)
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include("/admin/users/#{admin.id}")
        expect(flash[:alert]).to be_present
      end
    end
  end
end
