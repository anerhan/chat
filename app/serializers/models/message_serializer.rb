class Models::MessageSerializer < ActiveModel::Serializer
  attributes :body, :user_name, :created_at, :room_token

  def user_name
    object.user.full_name if object.user
  end

  def room_token
    object.room.token
  end

  def created_at
    object.created_at.strftime('%H:%M')
  end
end
