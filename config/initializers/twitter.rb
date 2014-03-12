# Twitter Initializer
# @desc: Configure our Twitter Factory so it can generate Twitter Clients with env-specific auth

require 'twitter_factory'

#Rails.application.config.to_prepare do
TwitterFactory.configure({
    :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
    :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
    :access_token => ENV['TWITTER_ACCESS_TOKEN'],
    :access_token_secret => ENV['TWITTER_ACCESS_TOKEN_SECRET']
})
#end
