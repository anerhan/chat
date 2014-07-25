Resque.redis = Redis.new(host: '127.0.0.1', port: 6379, password: nil)
Resque.redis.namespace = "resque:chat:#{Rails.env}"
Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }

Resque::Server.use(Rack::Auth::Basic) do |user, password|
   user == 'admin' && password == 'admin'
end if Rails.env.production?
