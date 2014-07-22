class Message
  include Base
  field :body
  belongs_to :user
end
