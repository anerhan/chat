class Models::RequestorSerializer < ActiveModel::Serializer
  attributes :full_name, :is_anonymous, :room_token, :messages_count

  def is_anonymous
    object.anonymous?
  end

  def room_token
    object.room.token
  end
end
