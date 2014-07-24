class User
  include Base
  include Authenticable
  include Trackable
  field :email
  field :name
  field :rooms_count, type: Integer, default: 0

  has_many :rooms, foreign_key: :requestor_id, inverse_of: 'Room'
  attr_accessor :room_token, :messages_count

  validates :email,
            length: { minimum: 6 },
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, allow_nil: true

  scope :anonymous, -> { where(email: nil) }
  scope :operators, -> { where(:email.ne => nil) }


  def self.free_operator
    operators.asc(:rooms_count).first
  end

  def anonymous?
    email.blank?
  end

  def full_name
    return "#{last_sign_in_ip}@Anonymous" if anonymous?
    [name.to_s, email.to_s].compact.reject(&:blank?).first
  end

  def responders
    if anonymous?
      available_rooms.map{|r| r.responder.room_token = r.token; r.responder.messages_count = r.messages.sum{|m| m.user_id.to_s != id.to_s ? 1 : 0}; r.responder }
    else
      available_rooms.map{|r| r.requestor.room_token = r.token; r.requestor.messages_count = r.messages.sum{|m| m.user_id.to_s != id.to_s ? 1 : 0};  r.requestor }
    end
  end

  def available_rooms
    if anonymous?
      [ rooms.worked.where(requestor_id: id).last || rooms.opened.where(requestor_id: id).last ].compact
    else
      rooms.worked.where(responder_id: id)
    end
  end
end
