class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.update_tracked_fields!(request.ip)
      @user.reset_access_token!
      warden.set_user @user
      redirect_to room_index_path
    else
      render :new
    end
  end

  private
    def user_params
      if params[:user].present?
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
end
