# Redis Initializer
# Provide environment-specific config to Redis, and setup pub-sub ping (hearbeat)

require 'redis'
require 'redis_stream_broker'

redis_auth_hash = {:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT']}
redis_auth_hash[:password] = ENV['REDIS_PASSWORD'] if ENV.has_key?('REDIS_PASSWORD')

# Configure the RedisStreamBroker auth so we never have to again
RedisStreamBroker.configure( redis_auth_hash )

# Setup global pub-sub ping on a timer in new thread
$redis_ping = Redis.new( redis_auth_hash ) 
ping_thread = Thread.new do
  while true
    $redis_ping.publish("ping","pong")
    sleep 20.seconds
  end
end

# Kill heartbeat & redis client on exit
at_exit do
  ping_thread.kill
  $redis_ping.quit
end
