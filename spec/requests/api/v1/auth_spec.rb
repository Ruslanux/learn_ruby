require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    context "with valid credentials" do
      it "returns a JWT token" do
        post "/api/v1/auth/login", params: { email: "test@example.com", password: "password123" }

        expect(response).to have_http_status(:ok)
        expect(json_response["token"]).to be_present
        expect(json_response["user"]["email"]).to eq("test@example.com")
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/api/v1/auth/login", params: { email: "test@example.com", password: "wrong" }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "POST /api/v1/auth/register" do
    let(:valid_params) do
      {
        email: "new@example.com",
        password: "password123",
        password_confirmation: "password123",
        username: "newuser"
      }
    end

    context "with valid params" do
      it "creates a new user and returns token" do
        expect {
          post "/api/v1/auth/register", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response["token"]).to be_present
        expect(json_response["user"]["username"]).to eq("newuser")
      end
    end

    context "with invalid params" do
      it "returns errors" do
        post "/api/v1/auth/register", params: { email: "invalid" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to be_present
      end
    end
  end

  describe "POST /api/v1/auth/refresh" do
    let(:user) { create(:user) }

    it "returns a new token" do
      post "/api/v1/auth/refresh", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["token"]).to be_present
    end

    it "requires authentication" do
      post "/api/v1/auth/refresh"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
