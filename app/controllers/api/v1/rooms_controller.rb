class Api::V1::RoomsController < Api::V1::BaseController
  def create
    room = current_user.rooms.build
    room.messages.build body: params[:message][:body], user: current_user, created_at: Time.now.utc
    room.save
    if current_user.save
      respond_with room, serializer: Api::V1::RoomSerializer
    end
  end
end
