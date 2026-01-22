module Admin
  class UsersController < BaseController
    include Paginatable

    before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_admin]

    def index
      @users = User.order(created_at: :desc)

      if params[:search].present?
        @users = @users.where("username ILIKE ? OR email ILIKE ?",
                              "%#{params[:search]}%", "%#{params[:search]}%")
      end

      @users = paginate(@users)
    end

    def show
      @submissions = @user.code_submissions.includes(:exercise).order(created_at: :desc).limit(20)
      @achievements = @user.achievements
      @progress = @user.user_progresses.includes(:exercise).completed.order(completed_at: :desc).limit(10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: t("admin.cannot_delete_self")
      else
        @user.destroy
        redirect_to admin_users_path, notice: t("admin.user_deleted")
      end
    end

    def toggle_admin
      if @user == current_user
        redirect_to admin_user_path(@user), alert: "You cannot change your own admin status."
      else
        @user.update!(admin: !@user.admin?)
        status = @user.admin? ? "granted" : "revoked"
        redirect_to admin_user_path(@user), notice: "Admin access #{status}."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :level, :total_points)
    end
  end
end
