class Api::V1::RoomsController < Api::V1::BaseController
  def create
    # room = current_user.open_room_by_params
    room = current_user.rooms.build
    room.messages.build body: params[:message][:body], user: current_user, created_at: Time.now.utc
    if room.save
      respond_with room, serializer: Api::V1::RoomSerializer
    end
  end

  def destroy
    if current_room && current_room.close!
      respond_with current_room, serializer: Api::V1::RoomSerializer
    else
      render_404
    end
  end
end
