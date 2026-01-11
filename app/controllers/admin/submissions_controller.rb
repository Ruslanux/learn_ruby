module Admin
  class SubmissionsController < BaseController
    PER_PAGE = 50

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

      @total_count = @submissions.count
      @page = (params[:page] || 1).to_i
      @submissions = @submissions.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
      @total_pages = (@total_count.to_f / PER_PAGE).ceil
    end

    def show
      @submission = CodeSubmission.find(params[:id])
    end
  end
end
