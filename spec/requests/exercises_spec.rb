require 'rails_helper'

RSpec.describe "Exercises", type: :request do
  let(:lesson) { create(:lesson) }
  let(:exercise) { create(:exercise, lesson: lesson, title: "Test Exercise") }

  describe "GET /lessons/:lesson_id/exercises/:id" do
    it "returns http success" do
      get lesson_exercise_path(lesson, exercise)
      expect(response).to have_http_status(:success)
    end

    it "displays exercise title" do
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include("Test Exercise")
    end

    it "displays lesson title" do
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include(lesson.title)
    end

    it "displays starter code" do
      exercise.update!(starter_code: "def hello\nend")
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include("Your Code")
    end

    it "displays test code section" do
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include("Tests (RSpec)")
      # Test code is HTML-escaped in the view
      expect(response.body).to include("RSpec.describe")
    end

    it "displays instructions" do
      exercise.update!(instructions: "Write a hello function")
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include("Instructions")
    end

    it "displays points value" do
      exercise.update!(points: 25)
      get lesson_exercise_path(lesson, exercise)
      expect(response.body).to include("25 points")
    end

    context "with hints" do
      before do
        exercise.update!(hints: ["Hint 1", "Hint 2"])
      end

      it "displays show hints button" do
        get lesson_exercise_path(lesson, exercise)
        expect(response.body).to include("Show Hints")
      end
    end

    context "when user is signed in" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "displays submit button" do
        get lesson_exercise_path(lesson, exercise)
        expect(response.body).to include("Submit Solution")
      end

      it "displays attempts counter" do
        get lesson_exercise_path(lesson, exercise)
        expect(response.body).to include("attempts")
      end

      it "shows previous submission code if exists" do
        create(:code_submission,
               user: user,
               exercise: exercise,
               code: "def my_solution; end",
               passed: false)
        get lesson_exercise_path(lesson, exercise)
        # The code will be base64 encoded in the data attribute
        expect(response.body).to include("data-code-editor-initial-code-value")
      end
    end

    context "when user is not signed in" do
      it "displays sign in prompt instead of submit" do
        get lesson_exercise_path(lesson, exercise)
        expect(response.body).to include("Sign in to Submit")
      end
    end

    context "with navigation" do
      let!(:prev_exercise) { create(:exercise, lesson: lesson, position: 1, title: "Previous") }
      let!(:current_exercise) { create(:exercise, lesson: lesson, position: 2, title: "Current") }
      let!(:next_exercise) { create(:exercise, lesson: lesson, position: 3, title: "Next") }

      it "shows previous exercise link" do
        get lesson_exercise_path(lesson, current_exercise)
        expect(response.body).to include("Previous: Previous")
      end

      it "shows next exercise link" do
        get lesson_exercise_path(lesson, current_exercise)
        expect(response.body).to include("Next: Next")
      end

      it "shows complete lesson link on last exercise" do
        get lesson_exercise_path(lesson, next_exercise)
        expect(response.body).to include("Complete Lesson")
      end
    end
  end

  describe "POST /lessons/:lesson_id/exercises/:id/run" do
    let(:exercise) do
      create(:exercise,
             lesson: lesson,
             test_code: <<~RUBY)
               RSpec.describe "hello" do
                 it "returns Hello!" do
                   expect(hello).to eq("Hello!")
                 end
               end
             RUBY
    end

    it "returns http success" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; "Hello!"; end' },
           as: :json
      expect(response).to have_http_status(:success)
    end

    it "returns JSON response" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; "Hello!"; end' },
           as: :json
      expect(response.content_type).to include("application/json")
    end

    it "executes passing code and returns success" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; "Hello!"; end' },
           as: :json

      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["test_results"]["examples"]).to be_present
    end

    it "executes failing code and returns failure" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; "Wrong!"; end' },
           as: :json

      json = JSON.parse(response.body)
      expect(json["success"]).to be false
    end

    it "returns error for empty code" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: '' },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("No code provided")
    end

    it "returns execution time" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; "Hello!"; end' },
           as: :json

      json = JSON.parse(response.body)
      expect(json["execution_time"]).to be_a(Numeric)
    end

    it "blocks forbidden patterns" do
      post run_lesson_exercise_path(lesson, exercise),
           params: { code: 'def hello; system("ls"); end' },
           as: :json

      json = JSON.parse(response.body)
      expect(json["success"]).to be false
      expect(json["errors"]).to include(match(/Forbidden pattern/))
    end

    context "without authentication" do
      it "still allows running tests" do
        post run_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /lessons/:lesson_id/exercises/:id/submit" do
    let(:user) { create(:user) }
    let(:exercise) do
      create(:exercise,
             lesson: lesson,
             points: 20,
             test_code: <<~RUBY)
               RSpec.describe "hello" do
                 it "returns Hello!" do
                   expect(hello).to eq("Hello!")
                 end
               end
             RUBY
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json
        expect(response).to have_http_status(:success)
      end

      it "creates a code submission" do
        expect {
          post submit_lesson_exercise_path(lesson, exercise),
               params: { code: 'def hello; "Hello!"; end' },
               as: :json
        }.to change(CodeSubmission, :count).by(1)
      end

      it "increments attempts count" do
        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json

        json = JSON.parse(response.body)
        expect(json["attempts"]).to eq(1)

        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json

        json = JSON.parse(response.body)
        expect(json["attempts"]).to eq(2)
      end

      it "saves the submitted code" do
        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: 'def hello; "Hello!"; end' },
             as: :json

        submission = CodeSubmission.last
        expect(submission.code).to eq('def hello; "Hello!"; end')
        expect(submission.user).to eq(user)
        expect(submission.exercise).to eq(exercise)
      end

      context "with passing solution" do
        it "marks progress as completed" do
          post submit_lesson_exercise_path(lesson, exercise),
               params: { code: 'def hello; "Hello!"; end' },
               as: :json

          json = JSON.parse(response.body)
          expect(json["completed"]).to be true
        end

        it "awards points to user" do
          expect {
            post submit_lesson_exercise_path(lesson, exercise),
                 params: { code: 'def hello; "Hello!"; end' },
                 as: :json
          }.to change { user.reload.total_points }.by(20)

          json = JSON.parse(response.body)
          expect(json["points_earned"]).to eq(20)
        end

        it "only awards points once" do
          post submit_lesson_exercise_path(lesson, exercise),
               params: { code: 'def hello; "Hello!"; end' },
               as: :json

          expect {
            post submit_lesson_exercise_path(lesson, exercise),
                 params: { code: 'def hello; "Hello!"; end' },
                 as: :json
          }.not_to change { user.reload.total_points }
        end
      end

      context "with failing solution" do
        it "does not mark as completed" do
          post submit_lesson_exercise_path(lesson, exercise),
               params: { code: 'def hello; "Wrong!"; end' },
               as: :json

          json = JSON.parse(response.body)
          expect(json["completed"]).to be false
        end

        it "does not award points" do
          expect {
            post submit_lesson_exercise_path(lesson, exercise),
                 params: { code: 'def hello; "Wrong!"; end' },
                 as: :json
          }.not_to change { user.reload.total_points }
        end

        it "still records the submission" do
          expect {
            post submit_lesson_exercise_path(lesson, exercise),
                 params: { code: 'def hello; "Wrong!"; end' },
                 as: :json
          }.to change(CodeSubmission, :count).by(1)

          submission = CodeSubmission.last
          expect(submission.passed).to be false
        end
      end

      it "returns error for empty code" do
        post submit_lesson_exercise_path(lesson, exercise),
             params: { code: '' },
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
