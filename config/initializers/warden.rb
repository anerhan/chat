Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda { |env| SessionsController.action(:new).call(env) }
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find id
end

Warden::Strategies.add(:password) do
  def valid?
    params['user'] && params['user']['email'] && params['user']['password']
  end

  def authenticate!
    user = User.find_by(email: params['user']['email']) if params['user']
    if user && user.valid_password?(params['user']['password'])
	    user.update_tracked_fields!(request.ip)
      user.reset_faye_token
      user.reset_access_token!
      success! user
    else
      fail "Invalid email or password"
    end
  end
end


# Warden::Strategies.add(:token) do
#   def valid?
#     params['access_token']
#   end

#   def authenticate!
#     user = User.find_by(access_token: params['access_token'])
#     if user
#       user.update_tracked_fields!(request)
#       success! user
#     else
#       fail "Invalid Token!"
#     end
#   end
# end
