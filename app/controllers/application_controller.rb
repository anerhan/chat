class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def signed_in?
    current_user.present?
  end
  helper_method :signed_in?

  def user_logout
    warden.logout
  end

  def current_user
    warden.user
  end
  helper_method :current_user

  def warden
    env['warden']
  end
end
