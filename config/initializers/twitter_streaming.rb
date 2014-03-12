# TwitterStreamWorker Initializer
# @desc:  Use a new thread to run our twitter stream worker
#         Worker listens on requested streams and publishes via Redis

require 'twitter_stream_worker'


# Worker will open its own threads, so this will not block
worker =  TwitterStreamWorker.new

# Ensure worker thread closes on exit
at_exit do
  worker.kill
end

