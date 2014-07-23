class Message
  include Base
  field :body
  belongs_to :user
  embedded_in :room
end
