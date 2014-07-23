class Api::V1::UsersController < Api::V1::BaseController
  def show
    respond_with current_user, serializer: Api::V1::UserSerializer
  end
end
