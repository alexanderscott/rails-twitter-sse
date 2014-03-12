# TODO integrate these into error-catching

module Errors

  # General errors
  class RedisConnectionError            < StandardError; end
  class PublicationNotAuthorized        < StandardError; end       
  class SubscriptionNotAuthorized       < StandardError; end      

  # Twitter stream worker error
  class StreamConnectionError           < StandardError; end       
  class TweetJsonParseError             < StandardError; end      
  class TweetInvalid                    < StandardError; end      
  class TwitterStreamRateLimited        < StandardError; end      


  # App/socket server
  class InvalidOperation                < StandardError; end      
  class WebsocketError                  < StandardError; end      
  class APIError                        < StandardError; end      

end
