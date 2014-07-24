require 'faye'
Faye::WebSocket.load_adapter 'thin'

require File.expand_path '../config/initializers/faye.rb', __FILE__

class ServerAuth
  def incoming message, callback
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['secret'] != FAYE['development']['secret']
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call message
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing message, callback
    if message['ext'] && message['ext']['secret']
      message['ext'] = {}
    end
    callback.call message
  end
end

faye_server = Faye::RackAdapter.new(:mount => FAYE['development']['mount'], :timeout => FAYE['development']['timeout'])
faye_server.add_extension ServerAuth.new
run faye_server
