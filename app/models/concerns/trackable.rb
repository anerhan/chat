module Trackable
  extend ActiveSupport::Concern

  included do
    field :last_sign_in_at,    type: DateTime, default: nil
    field :last_sign_in_ip,    type: String,   default: nil
    field :sign_in_count,      type: Integer,  default: 0
  end

  def update_tracked_fields!(ip_address = '0.0.0.0')
    self.last_sign_in_at = Time.now.utc
    self.last_sign_in_ip = ip_address
    self.sign_in_count += 1
    save(:validate => false) or raise "Behavior trackable could not save #{inspect}." \
      "Please make sure a model using trackable can be saved at sign in."
  end
end
