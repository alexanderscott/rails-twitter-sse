Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'], 
    {
      :image_size => 'original',
      :x_auth_access_type => 'write'
    }

end
