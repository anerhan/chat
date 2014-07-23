class Api::V1::RoomSerializer < ActiveModel::Serializer
  delegate  :current_user, to: :scope

  attributes :token, :is_closed, :closed_at, :user_name
  has_one :last_message, serializer: Api::V1::MessageSerializer
  def user_name
    if current_user.id == object.requestor_id
      object.responder ? object.responder.full_name : 'Not Connected Yet'
    else
      object.requestor.full_name
    end
  end

  def last_message
    object.messages.last
  end
end
