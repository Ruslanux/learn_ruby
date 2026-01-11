require 'rails_helper'

RSpec.describe "Admin::Exercises", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:lesson) { create(:lesson) }

  before { sign_in admin }

  describe "GET /admin/exercises" do
    it "returns success" do
      get admin_exercises_path
      expect(response).to have_http_status(:success)
    end

    it "lists all exercises" do
      exercise = create(:exercise, title: "Test Exercise", lesson: lesson)

      get admin_exercises_path

      expect(response.body).to include("Test Exercise")
    end
  end

  describe "GET /admin/exercises/:id" do
    let(:exercise) { create(:exercise, lesson: lesson) }

    it "returns success" do
      get admin_exercise_path(exercise)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/exercises/new" do
    it "returns success" do
      get new_admin_exercise_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/exercises" do
    let(:valid_params) do
      {
        exercise: {
          lesson_id: lesson.id,
          title: "New Exercise",
          description: "Description",
          instructions: "Instructions",
          starter_code: "def hello\nend",
          solution_code: "def hello\n  'Hello'\nend",
          test_code: "RSpec.describe 'hello' do\nend",
          points: 10,
          position: 1
        }
      }
    end

    it "creates a new exercise" do
      expect {
        post admin_exercises_path, params: valid_params
      }.to change(Exercise, :count).by(1)
    end
  end

  describe "PATCH /admin/exercises/:id" do
    let(:exercise) { create(:exercise, lesson: lesson) }

    it "updates the exercise" do
      patch admin_exercise_path(exercise), params: { exercise: { title: "Updated Title" } }
      expect(exercise.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /admin/exercises/:id" do
    let!(:exercise) { create(:exercise, lesson: lesson) }

    it "deletes the exercise" do
      expect {
        delete admin_exercise_path(exercise)
      }.to change(Exercise, :count).by(-1)
    end
  end
end
