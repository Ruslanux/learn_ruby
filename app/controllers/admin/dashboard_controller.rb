module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_users: User.count,
        active_users_today: User.where("last_activity_date = ?", Date.current).count,
        total_lessons: Lesson.count,
        total_exercises: Exercise.count,
        total_submissions: CodeSubmission.count,
        submissions_today: CodeSubmission.where("created_at >= ?", Date.current.beginning_of_day).count,
        pass_rate: calculate_pass_rate,
        total_achievements_earned: UserAchievement.count
      }

      @recent_submissions = CodeSubmission.includes(:user, :exercise)
                                          .order(created_at: :desc)
                                          .limit(10)

      @popular_exercises = Exercise.joins(:code_submissions)
                                   .group("exercises.id")
                                   .order("COUNT(code_submissions.id) DESC")
                                   .limit(5)
                                   .select("exercises.*, COUNT(code_submissions.id) as submission_count")

      @top_users = User.order(total_points: :desc).limit(5)
    end

    private

    def calculate_pass_rate
      total = CodeSubmission.count
      return 0 if total.zero?

      passed = CodeSubmission.where(passed: true).count
      ((passed.to_f / total) * 100).round(1)
    end
  end
end
