class Api::V1::MessagesController < Api::V1::BaseController
  def index
    # binding.pry
    render json: current_room.messages, each_serializer: Api::V1::MessageSerializer
  end

  def create
    message = Message.new(body: params[:message][:body], user: current_user)
    message.created_at = Time.now.utc
    current_room.messages << message
    if current_room.save
      render json: message, serializer: Api::V1::MessageSerializer
    end
  end
end
