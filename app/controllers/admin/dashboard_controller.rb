module Admin
  class DashboardController < BaseController
    def index
      dashboard = Admin::DashboardService.new

      @stats = dashboard.stats
      @recent_submissions = dashboard.recent_submissions
      @popular_exercises = dashboard.popular_exercises
      @top_users = dashboard.top_users
    end
  end
end
