# frozen_string_literal: true

module Admin
  class DashboardService
    def initialize
      @today = Date.current
    end

    def stats
      @stats ||= {
        total_users: total_users,
        active_users_today: active_users_today,
        total_lessons: total_lessons,
        total_exercises: total_exercises,
        total_submissions: total_submissions,
        submissions_today: submissions_today,
        pass_rate: pass_rate,
        total_achievements_earned: total_achievements_earned
      }
    end

    def recent_submissions(limit: 10)
      CodeSubmission.includes(:user, :exercise)
                    .order(created_at: :desc)
                    .limit(limit)
    end

    def popular_exercises(limit: 5)
      PopularExercisesQuery.new(limit: limit).call
    end

    def top_users(limit: 5)
      User.order(total_points: :desc).limit(limit)
    end

    private

    def total_users
      User.count
    end

    def active_users_today
      User.where(last_activity_date: @today).count
    end

    def total_lessons
      Lesson.count
    end

    def total_exercises
      Exercise.count
    end

    def total_submissions
      @total_submissions ||= CodeSubmission.count
    end

    def submissions_today
      CodeSubmission.where("created_at >= ?", @today.beginning_of_day).count
    end

    def pass_rate
      return 0 if total_submissions.zero?

      passed = CodeSubmission.where(passed: true).count
      ((passed.to_f / total_submissions) * 100).round(1)
    end

    def total_achievements_earned
      UserAchievement.count
    end
  end
end
