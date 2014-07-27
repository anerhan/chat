module FayeTockenable
  extend ActiveSupport::Concern
  included do
    field :faye_token, type: String, default: nil
  end

  def reset_faye_token!
    reset_faye_token
    self if save(validate: false)
  end

  def reset_faye_token
    self.faye_token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
  end
end

