# TwitterFactory
# @desc:  Module wrapper for instantiating Twitter clients with pre-configured auth.
#         (Mainly so we do not have to re-reference env attributes in our controllers)
#         Provide a custom Tweet class and transformation from the bulky Twitter::Tweet

require 'twitter'

module TwitterFactory

  # Store config from initializer
  def self.configure(config = {})
    @config = config
  end

  class Tweet
    attr_accessor(:text, :user_tw_id, :user_nickname, :user_image, :created_at)

    def initialize(tw_object)
      @tweet = {
        :text => tw_object.text,
        :user_tw_id => tw_object.user.id.to_s,
        :user_nickname => tw_object.user.screen_name,
        :user_image => tw_object.user.profile_image_url.to_s,
        :created_at => tw_object.created_at.to_s
      }
      @tweet.each do |name, value|
        send("#{name}=", value)
      end
    end

    # Convert to a hash for JSON stringifying and publishing
    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash["tweet"]
    end

  end

  # Use the user's OAuth info to make REST calls on their behalf (easier rate limits)
  def self.new_rest_client( oauth_token = '', oauth_secret = '' )
    config = {
      :consumer_key => @config[:consumer_key],
      :consumer_secret => @config[:consumer_secret],
      :access_token => oauth_token,
      :access_token_secret => oauth_secret
    }
    Twitter::REST::Client.new(config)
  end

  # Have to use our own app account OAuth for the streaming client =(
  def self.new_streaming_client
    Twitter::Streaming::Client.new( @config )
  end

end
