module Admin
  class SubmissionsController < BaseController
    include Paginatable

    def index
      @submissions = CodeSubmission.includes(:user, :exercise)
                                   .order(created_at: :desc)

      @filter = params[:filter]

      case @filter
      when "passed"
        @submissions = @submissions.where(passed: true)
      when "failed"
        @submissions = @submissions.where(passed: false)
      end

      @submissions = paginate(@submissions)
    end

    def show
      @submission = CodeSubmission.find(params[:id])
    end
  end
end
