class Api::V1::ResponderSerializer < ActiveModel::Serializer
  delegate  :current_user, to: :scope
  attributes :full_name, :is_anonymous, :room_token, :messages_count

  # def room_token
  #   object
  # end
  # has_many :worked_rooms, serializer: Api::V1::RoomSerializer
  # # has_many :worked_rooms, serializer: Api::V1::RoomSerializer
  # # has_many :opened_rooms, serializer: Api::V1::RoomSerializer
  # has_many :available_rooms, serializer: Api::V1::RoomSerializer

  def is_anonymous
    object.anonymous?
  end
end
