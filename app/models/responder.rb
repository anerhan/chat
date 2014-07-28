class Responder
  include Base
  field :unread_count, type: Integer, default: 1
  embedded_in :room
  embeds_one :user
end
