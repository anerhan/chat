class Message
  include Base
  field :body
  belongs_to :user
  embedded_in :room

  after_create :update_room_responders, :broadcast

  def broadcast_responders
    room.responders.excludes 'user._id' => user_id
  end

  private
    def update_room_responders
      rs = room.responders.where('user._id' => user_id)
      if rs.count == 0
        room.responders << Responder.new(user: user)
        room.save
      end
    end

    def broadcast
      broadcast_responders.each do |r|
        Resque.enqueue(Worker::WebSockets, :new_message, r.user.faye_token, Models::MessageSerializer.new(self))
      end
    end
end
