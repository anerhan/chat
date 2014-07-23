class User
  include Base
  include Authenticable
  include Trackable
  field :email
  field :name

  has_many :rooms, foreign_key: :requestor_id, inverse_of: 'Room'

  validates :email,
            length: { minimum: 6 },
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, allow_nil: true

  scope :anonymous, -> { where(email: nil) }
  scope :operators, -> { where(:email.ne => nil) }

  def anonymous?
    email.blank?
  end

  def full_name
    return "#{last_sign_in_ip}@Anonymous" if anonymous?
    [name.to_s, email.to_s].compact.reject(&:blank?).first
  end
end
