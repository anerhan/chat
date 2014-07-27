 # RAILS_ENV=production bundle exec thin -p 9295 -R ./faye.ru -P ./tmp/pids/faye.pid start
 # curl http://localhost:9295/faye/chat -d 'message={"channel":"/messages/new", "data":"hello", "ext":{"secret":"slkjsafhkjfaskjh7asf9f8as7fas8f0a"}}'

## START RESQUES
#  PIDFILE=./tmp/pids/resque.pid QUEUE=* RAILS_ENV=development bundle exec rake resque:work
## START FAYE
#   RAILS_ENV=production bundle exec thin -p 9295 -R ./faye.ru -P ./tmp/pids/faye.pid start


require 'faye'
Faye::WebSocket.load_adapter 'thin'
require File.expand_path '../config/initializers/faye.rb', __FILE__
FAYE_CONFIG = FAYE['development']

class ServerAuth
  def incoming message, request, callback
    csrf_token = message['ext'] && message['ext'].delete('csrfToken')
    access_token = message['ext'] && message['ext'].delete('accessToken')
    if message['channel'] !~ %r{^/meta/}
      auth = csrf_token ? (csrf_token == FAYE_CONFIG['secret']) : false
      message['error'] = 'Invalid secret token' if !auth
    end
    callback.call message
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing message, callback
    if message['ext']
      message['ext'] = {}
    end
    callback.call message
  end
end

faye_server = Faye::RackAdapter.new(mount: "/#{FAYE_CONFIG['mount']}", timeout: FAYE_CONFIG['timeout'] )
faye_server.add_extension ServerAuth.new

# faye_server.on(:handshake) do |client_id|
#   p "[ HandShake ] => #{client_id}"
# end

# faye_server.on(:subscribe) do |client_id, channel|
#   p "[ Subscribe ] => #{client_id} : #{channel}"
# end

# faye_server.on(:unsubscribe) do |client_id, channel|
#   p "[ UnSubscribe ] => #{client_id} : #{channel}"
# end

# faye_server.on(:disconnect) do |client_id, channel|
#   p "[ Disconnect ] => #{client_id}: #{channel}"
#   p "************ Session ************************"
# end

# faye_server.on(:publish) do |client_id, channel, data|
#   p "[ Publish ] => #{client_id}: #{channel} => #{data}"
# end
run faye_server


