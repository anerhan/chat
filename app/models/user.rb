class User
  include Base
  include Authenticable
  include Trackable
  field :email
  field :name
  validates :email,
            length: { minimum: 6 },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, allow_nil: true

  def anonymous?
    email.blank?
  end

  def full_name
    return "#{last_sign_in_ip}@Anonymous" if anonymous?
    [name.to_s, email.to_s].compact.reject(&:blank?).first
  end
end
