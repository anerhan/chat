class Message
  include Base
  field :body
  belongs_to :user
  embedded_in :room

  after_create :broadcast

  def broadcast_responders
    User.all_in id: ((room.messages.pluck(:user_id) + [room.requestor_id, room.responder_id]).uniq - [user_id])
  end

  private
    def broadcast
      broadcast_responders.each do |r|
        Resque.enqueue(Worker::WebSockets, :new_message, r.faye_token, Models::MessageSerializer.new(self))
      end
    end
end
