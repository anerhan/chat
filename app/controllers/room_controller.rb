class RoomController < ApplicationController
  def index
    session[:_csrf_token] = FAYE[Rails.env]['secret']
    # session[:_csrf_access_token] = current_user.access_token
    # render text: 'Hello From Index'
  end
end
