require 'rails_helper'

RSpec.describe "Admin::Lessons", type: :request do
  let(:admin) { create(:user, admin: true) }

  before { sign_in admin }

  describe "GET /admin/lessons" do
    it "returns success" do
      get admin_lessons_path
      expect(response).to have_http_status(:success)
    end

    it "lists all lessons" do
      lesson = create(:lesson, title: "Test Lesson")

      get admin_lessons_path

      expect(response.body).to include("Test Lesson")
    end
  end

  describe "GET /admin/lessons/:id" do
    let(:lesson) { create(:lesson) }

    it "returns success" do
      get admin_lesson_path(lesson)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/lessons/new" do
    it "returns success" do
      get new_admin_lesson_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/lessons" do
    let(:valid_params) do
      {
        lesson: {
          title: "New Lesson",
          description: "A description",
          module_number: 1,
          position: 1,
          difficulty: "beginner",
          ruby_version: "3.4"
        }
      }
    end

    it "creates a new lesson" do
      expect {
        post admin_lessons_path, params: valid_params
      }.to change(Lesson, :count).by(1)
    end

    it "redirects to the lesson" do
      post admin_lessons_path, params: valid_params
      expect(response).to have_http_status(:redirect)
      expect(response.location).to include("/admin/lessons/#{Lesson.last.id}")
    end
  end

  describe "GET /admin/lessons/:id/edit" do
    let(:lesson) { create(:lesson) }

    it "returns success" do
      get edit_admin_lesson_path(lesson)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/lessons/:id" do
    let(:lesson) { create(:lesson) }

    it "updates the lesson" do
      patch admin_lesson_path(lesson), params: { lesson: { title: "Updated Title" } }
      expect(lesson.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /admin/lessons/:id" do
    let!(:lesson) { create(:lesson) }

    it "deletes the lesson" do
      expect {
        delete admin_lesson_path(lesson)
      }.to change(Lesson, :count).by(-1)
    end
  end
end
