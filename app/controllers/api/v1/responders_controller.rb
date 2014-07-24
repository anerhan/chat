class Api::V1::RespondersController < Api::V1::BaseController
  def index
    render json: current_user.responders, each_serializer: Api::V1::ResponderSerializer
  end
end
