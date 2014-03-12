# SocketsController
# @desc: Controls SSE connections & Redis subscriptions for logged in users

require 'redis_stream_broker'

class SocketsController < ApplicationController
  
  # Needed for response.stream/SSE
  include ActionController::Live

  def connect
    response.headers['Content-Type'] = 'text/event-stream'

    if is_authenticated?
      puts "User: #{current_user[:id].to_s} connecting to stream..."
      _stream 
    else 
      render nothing: true
    end  
  end


  private

    def _stream
      puts "Stream initializing - subscribing to Redis and beginning SSE writes"

      # Create a new Redis instance and subscribe to user timeline publications
      # Because this subscription is blocking, we need to also subscribe to a heartbeat. Writing to
      # the response stream using this heartbeat will let us know if the stream is still connected/active.
      #@redis_sub = RedisStreamBroker::Client.new
      @redis_sub = RedisStreamBroker.new_redis_client

      begin

        # The user's timeline subscription
        sub_key = RedisStreamBroker.get_user_subscription_key( current_user[:id] )

        # Create a new Redis client subscription for this stream
        @redis_sub.subscribe([ sub_key, 'ping' ]) do |on|
          on.message do |channel, msg|
            puts "Writing to client with channel:: #{channel}, msg:: #{msg}"

            # Format as standard SSE
            if channel == sub_key
              response.stream.write(_sse(msg, { event: 'tweet' }))
            else 
              response.stream.write(_sse(msg, { event: "#{channel}" }))
            end
          end
        end

      rescue IOError
        # Client Disconnected
        puts "IO Error, client disconnected"

      ensure
        puts "Closing stream and Redis subscription"
        @redis_sub.quit
        response.stream.close
      end

    end

    def _sse(object, options = {})
      (options.map{|k,v| "#{k}: #{v}" } << "data: #{object}").join("\n") + "\n\n"
    end

end
