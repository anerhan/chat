class Api::V1::BaseController < ActionController::Base
  layout false
  respond_to :json
  before_filter :set_request_format, :authenticate_by_token

  serialization_scope :view_context
  helper_method :current_user, :current_room

  USER_AUTH_HEADER = "X-Auth-Token"
  ROOM_TOKEN_HEADER = "X-Room-Token"

  def signed_in?
    current_user.present?
  end
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find_by(access_token: access_token) if access_token.present?
  end

  def current_room
    @current_room ||= Room.find_by(token: room_token) if room_token.present?
  end

  def access_token
    @access_token ||= request.headers[USER_AUTH_HEADER]
  end

  def room_token
    @room_token ||= request.headers[ROOM_TOKEN_HEADER]
  end

  private
    def authenticate_by_token
      render_401 unless signed_in?
    end
    def set_request_format
      request.format = "json"
    end
    def respond_with_code status, message = nil
      render json: { message: message }, status: status
    end
    def render_401 message = nil
      respond_with_code :unauthorized, 'Invalid Auth'
    end
    def render_404 message = nil
      respond_with_code :not_found, 'Document not Found'
    end
end
