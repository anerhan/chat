class Api::V1::MessageSerializer < ActiveModel::Serializer
  delegate  :current_user, to: :scope
  attributes :body, :user_name, :created_at

  def user_name
    object.user.full_name if object.user
  end

  def created_at
    object.created_at.strftime('%H:%M')
  end
end
