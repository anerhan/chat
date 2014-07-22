class SessionsController < ApplicationController

  def new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate(:password)
    if signed_in?
      redirect_to room_index_path
    else
      render new_session_path
    end
  end

  def destroy
    user_logout
    redirect_to root_path
  end
end
