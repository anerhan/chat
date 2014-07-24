class Room
  include Base
  field :token
  field :is_closed, type: Boolean, default: false
  field :closed_at, type: DateTime

  belongs_to :requestor, class_name: 'User'
  belongs_to :responder, class_name: 'User'
  embeds_many :messages

  before_create :generate_token, :set_responder

  validates :requestor_id, presence: true

  scope :active, -> { where(is_closed: false, :closed_at => nil) }
  scope :closed, -> { where(is_closed: true, :closed_at.ne => nil) }
  scope :opened, -> { active.where(:requestor_id.ne => nil,  responder_id: nil).desc(:created_at) }
  scope :worked, -> { active.where(:requestor_id.ne => nil,  :responder_id.ne => nil).desc(:created_at) }

  def close!
    self.is_closed = true
    self.closed_at = Time.now.utc
    responder = self.responder
    responder.rooms_count -= 1
    save && responder.save
  end

  private
    def set_responder
      operator = User.free_operator
      if operator
        operator.rooms_count += 1
        operator.save
        self.responder = operator
      end
    end

    def generate_token
      self.token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
    end
end
