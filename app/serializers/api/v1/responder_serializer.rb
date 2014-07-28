class Api::V1::ResponderSerializer < ActiveModel::Serializer
  delegate  :current_user, to: :scope
  attributes :full_name, :is_anonymous, :room_token, :messages_count

  def is_anonymous
    object.anonymous?
  end
end
