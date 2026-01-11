module Admin
  class LessonsController < BaseController
    before_action :set_lesson, only: [:show, :edit, :update, :destroy]

    def index
      @lessons = Lesson.includes(:exercises)
                       .order(:module_number, :position)
    end

    def show
      @exercises = @lesson.exercises.order(:position)
    end

    def new
      @lesson = Lesson.new
    end

    def create
      @lesson = Lesson.new(lesson_params)

      if @lesson.save
        redirect_to admin_lesson_path(@lesson), notice: "Lesson was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @lesson.update(lesson_params)
        redirect_to admin_lesson_path(@lesson), notice: "Lesson was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson.destroy
      redirect_to admin_lessons_path, notice: "Lesson was successfully deleted."
    end

    private

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:title, :description, :module_number, :position, :difficulty, :ruby_version)
    end
  end
end
