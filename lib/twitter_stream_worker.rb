# TwitterStreamWorker
# @desc: Connect to Twitter Streaming API and listen on our active users' timelines
#        User "activity" is measured via Redis z-set timestamps
#        Refresh the Twitter stream when a new user is created with their Twitter ID

require 'twitter'
require 'twitter_factory'
require 'thread'
require 'redis_stream_broker'

class TwitterStreamWorker

  class << self

    def initialize (config = {})
      puts "StreamWorker initialized"
    end

    # Opens a new thread for the Twitter stream after closing the existing thread (if it exists)
    def restart_stream
      puts "Restarting Twitter stream"

      @stream_thread.kill if @stream_thread

      @stream_thread = Thread.new do

        # Sometimes Twitter streaming API can spit back errors, so let's catch them
        begin 
          @tw_stream_client = TwitterFactory.new_streaming_client
        rescue
          raise "Error connecting to twitter stream"
        end

        # Get active user Twitter IDs from the Redis z-set
        @user_ids = RedisStreamBroker.get_active_streams.join(',')

        puts "StreamWorker creating stream to follow user_ids: "
        p @user_ids

        #@tw_stream_client.site(:follow => @user_ids) do |tw_object|
        @tw_stream_client.filter(:follow => @user_ids) do |tw_object|

          # Check if stream return is a tweet (could be direct message, follow request, etc)
          if tw_object.is_a?(Twitter::Tweet)
            puts "Received tweet #{tw_object.text}"

            # Grab only the params we need to publish
            tweet = TwitterFactory::Tweet.new(tw_object).to_hash

            # Publish tweet to user's subscribed channel
            RedisStreamBroker.publish_to_user_stream( tweet[:user_tw_id], tweet )
          end
        end
      end
    end

    def new
      puts "Creating a new Twitter Stream Worker"

      restart_stream

      # This is the main worker Thread, and what 'new' returns
      # It listens for new users to join, and then will restart the Twitter 
      # stream with the new ID
      @redis_thread = Thread.new do 
        @redis_sub = RedisStreamBroker.new_redis_client
        @redis_sub.subscribe([ RedisStreamBroker.get_new_user_stream_channel ])  do |on|
          on.message do |channel, msg|
            puts "New user has joined, restarting Twitter stream for new id #{msg}"
            redis_test = RedisStreamBroker.new_redis_client
            redis_test.publish("WORKS", "WORKS")
            restart_stream
          end
        end
      end

    end
    
    def close
      @redis_thread.kill if @redis_thread
      @stream_thread.kill if @stream_thread
    end
  end

end
