require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  describe "GET /lessons" do
    it "returns http success" do
      get lessons_path
      expect(response).to have_http_status(:success)
    end

    it "displays lessons grouped by module" do
      lesson1 = create(:lesson, module_number: 1, position: 1, title: "Hello World")
      lesson2 = create(:lesson, module_number: 2, position: 1, title: "Data Structures")

      get lessons_path

      expect(response.body).to include("Hello World")
      expect(response.body).to include("Data Structures")
      expect(response.body).to include("Ruby Basics")
      expect(response.body).to include("Working with Data")
    end

    it "shows empty state when no lessons exist" do
      get lessons_path
      expect(response.body).to include("No lessons available yet")
    end

    context "when user is signed in" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "displays progress bars" do
        create(:lesson, module_number: 1, position: 1)
        get lessons_path
        expect(response.body).to include("Progress")
      end
    end
  end

  describe "GET /lessons/:id" do
    let(:lesson) { create(:lesson, title: "Test Lesson", description: "A test lesson") }

    it "returns http success" do
      get lesson_path(lesson)
      expect(response).to have_http_status(:success)
    end

    it "displays lesson details" do
      get lesson_path(lesson)

      expect(response.body).to include("Test Lesson")
      expect(response.body).to include("A test lesson")
    end

    it "displays exercises for the lesson" do
      exercise = create(:exercise, lesson: lesson, title: "Exercise 1")

      get lesson_path(lesson)

      expect(response.body).to include("Exercise 1")
    end

    it "shows empty state when no exercises" do
      get lesson_path(lesson)
      expect(response.body).to include("No exercises available")
    end

    context "when user is signed in" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "displays progress information" do
        get lesson_path(lesson)
        expect(response.body).to include("Your Progress")
      end

      it "shows Start Learning button" do
        create(:exercise, lesson: lesson)
        get lesson_path(lesson)
        expect(response.body).to include("Start Learning")
      end
    end

    context "when user is not signed in" do
      it "shows sign in prompt" do
        create(:exercise, lesson: lesson)
        get lesson_path(lesson)
        expect(response.body).to include("Sign in to start")
      end
    end
  end
end
