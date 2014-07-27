# require File.expand_path "#{Rails.root}/config/initializers/faye.rb"
module Worker
  class WebSockets
    @queue = "websockets"
    FAYE_CONFIG = FAYE[Rails.env.to_s]
    FAYE_URL = "http://#{FAYE_CONFIG['host']}:#{FAYE_CONFIG['port']}/#{FAYE_CONFIG['mount']}"

    def self.perform(task, *args)
      send(task, *args)
    end

    def self.new_message(faye_token, message)
      to_send = { channel: "/#{faye_token}/messages", data: message }.deep_merge!({ ext: { csrfToken: FAYE_CONFIG['secret'] }})
      Curl.put(FAYE_URL, to_send.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
      end
    end

    def self.new_room(faye_token, room)
      to_send = { channel: "/#{faye_token}/rooms", data: room }.deep_merge!({ ext: { csrfToken: FAYE_CONFIG['secret'] }})
      Curl.put(FAYE_URL,to_send.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
      end
    end

    def self.close_room(faye_token, room)
      to_send = { channel: "/#{faye_token}/messages", data: room }.deep_merge!({ ext: { csrfToken: FAYE_CONFIG['secret'] }})
      Curl.put(FAYE_URL, to_send.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
      end
    end
  end
end


