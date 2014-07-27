class RoomController < ApplicationController
  def index
    session[:_csrf_token] = FAYE[Rails.env]['secret']
  end
end
