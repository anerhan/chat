module Worker
  class Messages
    @queue = "messages"

    def self.perform(task, *args)
      send(task, *args)
    end

    def self.send_message(faye_url, channel, data, options = {})
      message = { channel: channel, data: data }.deep_merge!(options)
      Curl.put(faye_url, message.to_json) do |curl|
          curl.headers['Content-Type'] = 'application/json'
      end
    end

  end
end


