require 'rails_helper'

RSpec.describe "Api::V1::Exercises", type: :request do
  let(:user) { create(:user) }
  let(:lesson) { create(:lesson) }
  let(:exercise) { create(:exercise, lesson: lesson) }

  describe "GET /api/v1/exercises/:id" do
    it "requires authentication" do
      get "/api/v1/exercises/#{exercise.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "returns exercise details" do
        get "/api/v1/exercises/#{exercise.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response["exercise"]["title"]).to eq(exercise.title)
        expect(json_response["exercise"]["starter_code"]).to be_present
        expect(json_response["exercise"]["test_code"]).to be_present
      end

      it "includes progress information" do
        get "/api/v1/exercises/#{exercise.id}", headers: auth_headers(user)

        expect(json_response["exercise"]["progress"]).to include(
          "status", "attempts", "completed"
        )
      end
    end
  end

  describe "POST /api/v1/exercises/:id/run" do
    it "requires authentication" do
      post "/api/v1/exercises/#{exercise.id}/run", params: { code: "puts 'test'" }
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "executes code and returns results" do
        post "/api/v1/exercises/#{exercise.id}/run",
             params: { code: exercise.solution_code },
             headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_response).to include("success", "output")
      end
    end
  end

  describe "POST /api/v1/exercises/:id/submit" do
    it "requires authentication" do
      post "/api/v1/exercises/#{exercise.id}/submit", params: { code: "puts 'test'" }
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "creates a code submission" do
        expect {
          post "/api/v1/exercises/#{exercise.id}/submit",
               params: { code: exercise.solution_code },
               headers: auth_headers(user)
        }.to change(CodeSubmission, :count).by(1)

        expect(response).to have_http_status(:ok)
      end

      it "returns submission results" do
        post "/api/v1/exercises/#{exercise.id}/submit",
             params: { code: exercise.solution_code },
             headers: auth_headers(user)

        expect(json_response).to include("success", "attempts", "completed")
      end

      context "when solution is correct" do
        it "updates progress to completed" do
          post "/api/v1/exercises/#{exercise.id}/submit",
               params: { code: exercise.solution_code },
               headers: auth_headers(user)

          progress = user.progress_for(exercise)
          expect(progress).to be_completed
        end

        it "awards points" do
          expect {
            post "/api/v1/exercises/#{exercise.id}/submit",
                 params: { code: exercise.solution_code },
                 headers: auth_headers(user)
          }.to change { user.reload.total_points }.by(exercise.points)
        end
      end
    end
  end
end
