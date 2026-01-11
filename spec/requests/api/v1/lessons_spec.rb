require 'rails_helper'

RSpec.describe "Api::V1::Lessons", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/lessons" do
    it "requires authentication" do
      get "/api/v1/lessons"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      let!(:lesson) { create(:lesson, title: "Test Lesson") }

      it "returns lessons list" do
        get "/api/v1/lessons", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["lessons"]).to be_an(Array)
        expect(json_response["lessons"].first["title"]).to eq("Test Lesson")
      end

      it "includes progress information" do
        get "/api/v1/lessons", headers: auth_headers(user)

        expect(json_response["lessons"].first["progress"]).to include(
          "completed", "total", "percentage"
        )
      end
    end
  end

  describe "GET /api/v1/lessons/:id" do
    let(:lesson) { create(:lesson) }
    let!(:exercise) { create(:exercise, lesson: lesson) }

    it "requires authentication" do
      get "/api/v1/lessons/#{lesson.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "returns lesson with exercises" do
        get "/api/v1/lessons/#{lesson.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["lesson"]["title"]).to eq(lesson.title)
        expect(json_response["lesson"]["exercises"]).to be_an(Array)
      end
    end
  end
end
