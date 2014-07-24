class Api::V1::UserSerializer < ActiveModel::Serializer
  delegate  :current_user, to: :scope
  attributes :name, :email, :is_anonymous
  # has_many :worked_rooms, serializer: Api::V1::RoomSerializer
  # has_many :opened_rooms, serializer: Api::V1::RoomSerializer
  has_many :available_rooms, serializer: Api::V1::RoomSerializer

  def is_anonymous
    object.anonymous?
  end
end
