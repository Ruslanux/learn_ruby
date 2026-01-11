module Admin
  class ExercisesController < BaseController
    before_action :set_exercise, only: [:show, :edit, :update, :destroy]
    before_action :set_lessons, only: [:new, :create, :edit, :update]

    def index
      @exercises = Exercise.includes(:lesson)
                           .order("lessons.module_number, lessons.position, exercises.position")
    end

    def show
      @submissions = @exercise.code_submissions
                              .includes(:user)
                              .order(created_at: :desc)
                              .limit(20)
    end

    def new
      @exercise = Exercise.new
      @exercise.lesson_id = params[:lesson_id] if params[:lesson_id]
    end

    def create
      @exercise = Exercise.new(exercise_params)

      if @exercise.save
        redirect_to admin_exercise_path(@exercise), notice: "Exercise was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @exercise.update(exercise_params)
        redirect_to admin_exercise_path(@exercise), notice: "Exercise was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      lesson = @exercise.lesson
      @exercise.destroy
      redirect_to admin_lesson_path(lesson), notice: "Exercise was successfully deleted."
    end

    private

    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def set_lessons
      @lessons = Lesson.order(:module_number, :position)
    end

    def exercise_params
      params.require(:exercise).permit(
        :lesson_id, :title, :description, :instructions,
        :starter_code, :solution_code, :test_code,
        :points, :position, hints: [], topics: []
      )
    end
  end
end
