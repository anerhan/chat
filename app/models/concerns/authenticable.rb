module Authenticable
  extend ActiveSupport::Concern
  included do
    field :encrypted_password, type: String, default: ''
    field :access_token, type: String, default: nil
    attr_reader :password
    attr_accessor :password_confirmation
    validates :password, length: { within: 4..40 }, confirmation: true, presence: true, if: :password_required?
    validates :password_confirmation, presence: true, if: :password_required?

    class << self
      # Generate a friendly string randomically to be used as token.
      def friendly_token
        SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      end

      # constant-time comparison algorithm to prevent timing attacks
      def secure_compare(a, b)
        return false if a.blank? || b.blank? || a.bytesize != b.bytesize
        l = a.unpack "C#{a.bytesize}"
        res = 0
        b.each_byte { |byte| res |= byte ^ l.shift }
        res == 0
      end
    end
  end

  def password=(new_password)
    @password = new_password
    self.encrypted_password = password_digest(@password) if @password.present?
  end

  def reset_access_token!
    self.access_token = self.class.friendly_token
    self if save(validate: false)
  end

  def valid_password?(password)
    return false if encrypted_password.blank?
    bcrypt = ::BCrypt::Password.new(encrypted_password)
    password = ::BCrypt::Engine.hash_secret("#{password}mister-x", bcrypt.salt)
    self.class.secure_compare(password, encrypted_password)
  end

  protected
    def password_required?
      password.present?
    end

    # Digests the password using bcrypt.
    def password_digest(password)
      ::BCrypt::Password.create("#{password}mister-x", cost: 10).to_s
    end
end

