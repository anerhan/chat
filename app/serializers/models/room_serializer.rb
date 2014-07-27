class Models::RoomSerializer < ActiveModel::Serializer
  attributes :token, :is_closed, :closed_at, :user_name, :requestor
  has_one :last_message, serializer: Models::MessageSerializer

  def user_name
    object.requestor.full_name
  end

  def requestor
    {
      full_name: object.requestor.full_name,
      is_anonymous: object.requestor.anonymous?,
      room_token: object.token,
      messages_count: 1
    }
  end


  def last_message
    object.messages.last
  end
end
